class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://billowing-river-ae2a.chasseuragace.workers.dev';

  static const String tasks = '/tasks';
  static const String projects = '/projects';
  static const String users = '/users';
  static const String health = '/health';
  static const String config = '/config';

  static const int connectTimeoutMs = 10000;
  static const int receiveTimeoutMs = 15000;
}
