import 'package:injectable/injectable.dart';

/// Module for registering external dependencies that require special handling
/// Note: SharedPreferences is registered manually in injection.dart
/// to ensure proper async initialization before other dependencies
@module
abstract class DiModule {
  // SharedPreferences is registered manually in injection.dart
  // This module exists to inform injectable about the type for dependency resolution
  // but we don't register it here to avoid double registration
}
