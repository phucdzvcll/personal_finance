import '../config/env_config.dart';

/// Application-wide constants
class AppConstants {
  /// App name from environment configuration
  static String get appName => EnvConfig.config.appName;

  // App Info
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
