# Internationalization (i18n) Setup

This document describes the multi-language support setup for the Personal Finance application.

## Overview

The application supports multiple languages:
- **English (en)** - Default language
- **Spanish (es)** - Español
- **French (fr)** - Français
- **Vietnamese (vi)** - Tiếng Việt

## Architecture

### Files Structure

```
lib/
  l10n/
    app_en.arb          # English translations
    app_es.arb          # Spanish translations
    app_fr.arb          # French translations
    app_vi.arb          # Vietnamese translations
    app_localizations.dart  # Generated localization class
  core/
    utils/
      language_service.dart  # Language management service
```

### Configuration Files

- `l10n.yaml` - Configuration for localization generation
- `pubspec.yaml` - Contains dependencies and l10n configuration

## Usage

### Accessing Translations in Widgets

Use the extension method `context.l10n` to access translations:

```dart
import '../../../app.dart';

Text(context.l10n.welcomeBack)
Text(context.l10n.signIn)
```

### Changing Language

To change the language programmatically:

```dart
import '../../../app.dart';
import '../../../core/utils/language_service.dart';

// Change to Spanish
context.changeLanguage(const Locale('es'));

// Change to French
context.changeLanguage(const Locale('fr'));

// Change to Vietnamese
context.changeLanguage(const Locale('vi'));

// Change to English
context.changeLanguage(const Locale('en'));
```

The language preference is automatically saved and will persist across app restarts.

### Language Service

The `LanguageService` provides utilities for language management:

```dart
// Get saved locale
final locale = await LanguageService.getSavedLocale();

// Save locale
await LanguageService.saveLocale(const Locale('es'));

// Get supported locales
final locales = LanguageService.getSupportedLocales();

// Get language display name
final name = LanguageService.getLanguageName(const Locale('es')); // Returns "Español"
final nameVi = LanguageService.getLanguageName(const Locale('vi')); // Returns "Tiếng Việt"
```

## Adding New Translations

### Step 1: Add to English ARB File

Edit `lib/l10n/app_en.arb` and add your new key:

```json
{
  "myNewKey": "My New Text",
  "@myNewKey": {
    "description": "Description of what this text is for"
  }
}
```

### Step 2: Add to Other Language Files

Add the same key to `app_es.arb`, `app_fr.arb`, and `app_vi.arb` with appropriate translations:

**app_es.arb:**
```json
{
  "myNewKey": "Mi Nuevo Texto"
}
```

**app_fr.arb:**
```json
{
  "myNewKey": "Mon Nouveau Texte"
}
```

**app_vi.arb:**
```json
{
  "myNewKey": "Văn Bản Mới Của Tôi"
}
```

### Step 3: Regenerate Localization Files

Run the following command to regenerate the localization files:

```bash
flutter gen-l10n
```

### Step 4: Use in Code

```dart
Text(context.l10n.myNewKey)
```

## Adding a New Language

### Step 1: Create New ARB File

Create a new file `lib/l10n/app_<language_code>.arb` (e.g., `app_de.arb` for German).

Copy all keys from `app_en.arb` and translate them.

### Step 2: Update Language Service

Add the new locale to `LanguageService.getSupportedLocales()`:

```dart
static List<Locale> getSupportedLocales() {
  return const [
    Locale('en', ''),
    Locale('es', ''),
    Locale('fr', ''),
    Locale('vi', ''),
    Locale('de', ''), // Add new language
  ];
}
```

Add the language name in `LanguageService.getLanguageName()`:

```dart
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
    case 'de':
      return 'Deutsch'; // Add new language
    default:
      return 'English';
  }
}
```

### Step 3: Update App Widget

Add the new locale to `supportedLocales` in `lib/app.dart`:

```dart
supportedLocales: const [
  Locale('en', ''),
  Locale('es', ''),
  Locale('fr', ''),
  Locale('vi', ''),
  Locale('de', ''), // Add new language
],
```

### Step 4: Regenerate

Run `flutter gen-l10n` to regenerate the localization files.

## Current Translations

The following strings are currently translated:

### Authentication
- Welcome messages
- Sign in/Sign up buttons
- Form labels and validation messages
- Error messages

### Navigation
- App name
- Page titles (Home, Settings)

### Settings
- Settings page content
- Language selection

## Best Practices

1. **Always use context.l10n**: Never hardcode strings in the UI. Always use the localization system.

2. **Keep ARB files in sync**: When adding a new key, make sure to add it to all language files.

3. **Use descriptive keys**: Use clear, descriptive keys like `welcomeBack` instead of `msg1`.

4. **Add descriptions**: Always add a `@key` entry with a description to help translators understand the context.

5. **Test all languages**: After adding translations, test the app in all supported languages to ensure proper display.

6. **Handle missing translations**: If a translation is missing, Flutter will fall back to the English version.

## Troubleshooting

### Translations not updating

1. Run `flutter gen-l10n` to regenerate files
2. Restart the app completely
3. Check that the key exists in all ARB files

### Language not persisting

- Ensure `SharedPreferences` is properly initialized
- Check that `LanguageService.saveLocale()` is being called

### Import errors

- Make sure `flutter pub get` has been run
- Verify that `flutter gen-l10n` has been executed
- Check that the import path matches the generated file location

## References

- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle)
