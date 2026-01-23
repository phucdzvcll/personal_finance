/// Application configuration based on environment
class AppConfig {
  final String appName;
  final String apiBaseUrl;
  final String environment;
  final bool enableLogging;
  final bool enableCrashReporting;

  const AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    required this.environment,
    required this.enableLogging,
    required this.enableCrashReporting,
  });

  // Development environment
  static const AppConfig dev = AppConfig(
    appName: 'Personal Finance (Dev)',
    apiBaseUrl: 'http://10.10.1.100:3000/api',
    environment: 'dev',
    enableLogging: true,
    enableCrashReporting: false,
  );

  // Staging environment
  static const AppConfig stg = AppConfig(
    appName: 'Personal Finance (Stg)',
    apiBaseUrl: 'https://api-stg.example.com/api',
    environment: 'stg',
    enableLogging: true,
    enableCrashReporting: true,
  );

  // Production environment
  static const AppConfig prod = AppConfig(
    appName: 'Personal Finance',
    apiBaseUrl: 'https://api.example.com/api',
    environment: 'prod',
    enableLogging: false,
    enableCrashReporting: true,
  );

  /// Get config based on flavor
  static AppConfig getConfig(String flavor) {
    switch (flavor.toLowerCase()) {
      case 'dev':
        return dev;
      case 'stg':
      case 'staging':
        return stg;
      case 'prod':
      case 'production':
        return prod;
      default:
        return dev; // Default to dev
    }
  }
}
