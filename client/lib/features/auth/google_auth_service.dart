import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService({this.serverClientId});

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
      throw StateError('Interactive Google authentication is not supported on this platform.');
    }
    return _signIn.authenticate();
  }

  Future<void> signOut() async {
    await initialize();
    await _signIn.signOut();
  }
}
