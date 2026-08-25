import 'package:flutter/material.dart';

import 'features/auth/login_screen.dart';

void main() {
  runApp(const UltimateApp());
}

class UltimateApp extends StatelessWidget {
  const UltimateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Privacy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const LoginScreen(),
    );
  }
}
