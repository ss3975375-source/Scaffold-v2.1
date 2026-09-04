import 'package:flutter/material.dart';

import 'features/auth/login_screen.dart';

void main() {
  runApp(const SDSDBApp());
}

class SDSDBApp extends StatelessWidget {
  const SDSDBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDS-DB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const LoginScreen(),
    );
  }
}
