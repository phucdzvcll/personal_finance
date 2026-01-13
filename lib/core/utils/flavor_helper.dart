import 'package:flutter/services.dart';
import '../config/env_config.dart';

/// Helper class to get flavor from platform
class FlavorHelper {
  static const MethodChannel _channel = MethodChannel('com.example.personal_finance/flavor');

  /// Get flavor from platform (Android/iOS)
  static Future<String> getFlavor() async {
    try {
      final String flavor = await _channel.invokeMethod('getFlavor');
      return flavor;
    } catch (e) {
      // Fallback to dev if platform channel fails
      return 'dev';
    }
  }

  /// Initialize environment configuration from platform flavor
  static Future<void> initialize() async {
    final flavor = await getFlavor();
    EnvConfig.initialize(flavor);
  }
}
