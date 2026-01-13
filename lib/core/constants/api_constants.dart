import '../config/env_config.dart';

/// API constants - Uses environment-specific configuration
class ApiConstants {
  /// Base URL from environment configuration
  static String get baseUrl => EnvConfig.config.apiBaseUrl;

  // Endpoints
  static const String login = '/v1/auth/login';
  static const String register = '/v1/auth/register';
  static const String refreshToken = '/v1/auth/refresh';
  
  // Add more endpoints as needed
}
