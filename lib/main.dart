import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/utils/flavor_helper.dart';
import 'di/injection.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize flavor and environment configuration
  await FlavorHelper.initialize();

  // Configure dependency injection
  await configureDependencies();

  runApp(const App());
}
