class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  final String apiBaseUrl;

  static const development = AppConfig(
    apiBaseUrl: 'http://10.0.2.2:8080',
  );
}
