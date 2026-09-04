import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleAuthService _auth = GoogleAuthService();
  bool _busy = false;
  String? _message;

  Future<void> _signIn() async {
    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final account = await _auth.authenticate();
      if (!mounted) return;
      setState(() {
        _message = 'Signed in as ${account.displayName ?? account.email}';
      });
    } on GoogleSignInException catch (error) {
      if (!mounted) return;
      setState(() {
        _message = 'Google sign-in error: ${error.code}\n${error.description ?? 'No additional details.'}';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _message = 'Google sign-in error: $error';
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const Icon(Icons.shield_outlined, size: 76),
                const SizedBox(height: 24),
                const Text(
                  'SDS-DB',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Private communication and secure file sharing, designed around security and user control.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _busy ? null : _signIn,
                    icon: const Icon(Icons.account_circle_outlined),
                    label: Text(_busy ? 'Signing in…' : 'Continue with Google'),
                  ),
                ),
                if (_message != null) ...[
                  const SizedBox(height: 16),
                  Text(_message!, textAlign: TextAlign.center),
                ],
                const SizedBox(height: 24),
                const Text(
                  'We will request only the identity information needed for account sign-in. Google credentials are never stored by this app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
