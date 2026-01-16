import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'app_language';
  static const Locale defaultLocale = Locale('en');

  /// Get the saved language locale
  static Future<Locale> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        return Locale(languageCode);
      }
    } catch (e) {
      // If there's an error, return default locale
    }
    return defaultLocale;
  }

  /// Save the selected language locale
  static Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Get list of supported locales
  static List<Locale> getSupportedLocales() {
    return const [
      Locale('en', ''), // English
      Locale('es', ''), // Spanish
      Locale('fr', ''), // French
      Locale('vi', ''), // Vietnamese
    ];
  }

  /// Get language name for display
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'vi':
        return 'Tiếng Việt';
      default:
        return 'English';
    }
  }
}
