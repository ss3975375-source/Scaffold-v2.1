import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<ApiHealth> checkHealth() async {
    final response = await _client
        .get(Uri.parse('$baseUrl/health'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception('API returned HTTP ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return ApiHealth(
      status: json['status'] as String? ?? 'unknown',
      service: json['service'] as String? ?? 'unknown',
      version: json['version'] as String? ?? 'unknown',
    );
  }

  void dispose() => _client.close();
}

class ApiHealth {
  const ApiHealth({
    required this.status,
    required this.service,
    required this.version,
  });

  final String status;
  final String service;
  final String version;
}
