import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService({this.serverClientId = _serverClientId});

  // Web OAuth client ID. This is an identifier, not a secret.
  static const String _serverClientId =
      '589049623901-054sbagiiqabcogo5l8kn5adudspc3hk.apps.googleusercontent.com';

  final String? serverClientId;
  final GoogleSignIn _signIn = GoogleSignIn.instance;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await _signIn.initialize(serverClientId: serverClientId);
    _initialized = true;
  }

  Future<GoogleSignInAccount> authenticate() async {
    await initialize();
    if (!_signIn.supportsAuthenticate()) {
      throw StateError(
        'Interactive Google authentication is not supported on this platform.',
      );
    }

    try {
      return await _signIn.authenticate();
    } on GoogleSignInException catch (error) {
      // Credential Manager can retain a stale authorization session. Error
      // [16] is surfaced as "canceled / Account reauth failed" in that case.
      // Revoke the stale authorization once, then give the user a clean retry.
      if (error.code == GoogleSignInExceptionCode.canceled &&
          (error.description?.contains('Account reauth failed') ?? false)) {
        try {
          await _signIn.disconnect();
        } catch (_) {
          // The original error is more useful if revocation itself fails.
        }
        return await _signIn.authenticate();
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await initialize();
    await _signIn.signOut();
  }

  Future<void> disconnect() async {
    await initialize();
    await _signIn.disconnect();
  }
}
