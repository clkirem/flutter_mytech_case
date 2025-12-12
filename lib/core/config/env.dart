class Env {
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://interview.test.egundem.com');

  static const String apiKey = String.fromEnvironment('API_KEY', defaultValue: 'test-api-key');

  static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: true);
}
