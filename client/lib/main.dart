import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/network/api_client.dart';

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
      home: const FoundationScreen(),
    );
  }
}

class FoundationScreen extends StatefulWidget {
  const FoundationScreen({super.key});

  @override
  State<FoundationScreen> createState() => _FoundationScreenState();
}

class _FoundationScreenState extends State<FoundationScreen> {
  late final ApiClient _api;
  String _status = 'Not checked';
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _api = ApiClient(baseUrl: AppConfig.development.apiBaseUrl);
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _checkApi() async {
    setState(() {
      _checking = true;
      _status = 'Checking…';
    });

    try {
      final health = await _api.checkHealth();
      if (!mounted) return;
      setState(() {
        _status = 'Online — ${health.service} ${health.version}';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = 'Unavailable';
      });
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ultimate Privacy')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 72),
              const SizedBox(height: 20),
              const Text(
                'Foundation build',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Backend status: $_status',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _checking ? null : _checkApi,
                child: Text(_checking ? 'Checking…' : 'Check API'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
