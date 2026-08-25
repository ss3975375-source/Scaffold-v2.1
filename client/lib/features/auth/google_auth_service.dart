import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService({this.serverClientId = _serverClientId});

  // OAuth client ID for the Ultimate Privacy Backend web application.
  // This is an identifier, not a secret. Backend secrets must never be placed
  // in the Android application.
  static const String _serverClientId =
      '589049623901-a6e0ptq2rqdi72grvukbq3rq3hh7mror.apps.googleusercontent.com';

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
    return _signIn.authenticate();
  }

  Future<void> signOut() async {
    await initialize();
    await _signIn.signOut();
  }
}
