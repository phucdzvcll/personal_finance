import 'package:flutter/foundation.dart';
import 'app_config.dart';

/// Environment configuration manager
class EnvConfig {
  static AppConfig? _config;
  static String? _flavor;

  /// Initialize environment configuration
  /// This should be called in main.dart before runApp
  static void initialize(String flavor) {
    _flavor = flavor;
    _config = AppConfig.getConfig(flavor);
    if (kDebugMode) {
      print('Environment: ${_config!.environment}');
      print('API Base URL: ${_config!.apiBaseUrl}');
    }
  }

  /// Get current environment configuration
  static AppConfig get config {
    if (_config == null) {
      throw Exception(
        'EnvConfig not initialized. Call EnvConfig.initialize() in main.dart',
      );
    }
    return _config!;
  }

  /// Get current flavor
  static String? get flavor => _flavor;

  /// Check if current environment is development
  static bool get isDev => _config?.environment == 'dev';

  /// Check if current environment is staging
  static bool get isStg => _config?.environment == 'stg';

  /// Check if current environment is production
  static bool get isProd => _config?.environment == 'prod';
}
