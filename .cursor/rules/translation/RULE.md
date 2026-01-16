---
description: "NEVER hardcode string values in the UI. ALWAYS use the translation system."
alwaysApply: true
---
# Translation Rule

## ⚠️ CRITICAL: Always Use Translations

**NEVER hardcode string values in the UI. ALWAYS use the translation system.**

## Rule

Every text string displayed to users MUST use `context.l10n` instead of hardcoded strings.

## ✅ Correct Usage

```dart
import '../../../app.dart';

// ✅ GOOD - Using translations
Text(context.l10n.welcomeBack)
Text(context.l10n.signIn)
labelText: context.l10n.email
return context.l10n.pleaseEnterEmail
```

## ❌ Incorrect Usage

```dart
// ❌ BAD - Hardcoded strings
Text('Welcome Back')
Text('Sign In')
labelText: 'Email'
return 'Please enter your email'
```

## Quick Checklist

Before committing code, verify:
- [ ] No hardcoded strings in `Text()` widgets
- [ ] No hardcoded strings in `labelText`, `hintText`, `placeholder`
- [ ] No hardcoded strings in validation messages
- [ ] No hardcoded strings in error messages
- [ ] No hardcoded strings in button labels
- [ ] No hardcoded strings in page titles

## Adding New Strings

1. Add the key to `lib/l10n/app_en.arb`
2. Add translations to all language files (`app_es.arb`, `app_fr.arb`, `app_vi.arb`)
3. Run `flutter gen-l10n`
4. Use `context.l10n.yourNewKey` in code

## Exception

Only exception: Debug/development-only strings that are never shown to end users.

---

**Remember: Every string users see must be translatable!**
