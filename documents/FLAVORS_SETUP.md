# Flutter Flavors Setup Guide

This project is configured with three flavors: **dev**, **stg**, and **prod**.

## Overview

Flavors allow you to build different versions of your app with different configurations:
- **dev**: Development environment with debug features enabled
- **stg**: Staging environment for testing
- **prod**: Production environment

## Configuration Files

### Environment Configuration
- `lib/core/config/app_config.dart` - Defines configuration for each environment
- `lib/core/config/env_config.dart` - Environment configuration manager
- `lib/core/utils/flavor_helper.dart` - Helper to get flavor from platform

### Android Configuration
- `android/app/build.gradle.kts` - Product flavors defined
- `android/app/src/main/AndroidManifest.xml` - Uses flavor-specific app name

### iOS Configuration
- `ios/Runner/AppDelegate.swift` - Method channel to pass flavor to Flutter
- Xcode schemes need to be configured (see iOS Setup below)

## Running Different Flavors

### Using Flutter CLI

**Development:**
```bash
flutter run --flavor dev -t lib/main.dart
```

**Staging:**
```bash
flutter run --flavor stg -t lib/main.dart
```

**Production:**
```bash
flutter run --flavor prod -t lib/main.dart
```

### Using Scripts

We've provided convenient scripts in the `scripts/` directory:

**Run:**
```bash
./scripts/run_dev.sh    # Run dev flavor
./scripts/run_stg.sh     # Run stg flavor
./scripts/run_prod.sh    # Run prod flavor
```

**Build:**
```bash
./scripts/build_dev.sh   # Build dev APK
./scripts/build_stg.sh   # Build stg APK
./scripts/build_prod.sh # Build prod APK
```

## Building for Release

### Android

**Development:**
```bash
flutter build apk --flavor dev --release
flutter build appbundle --flavor dev --release
```

**Staging:**
```bash
flutter build apk --flavor stg --release
flutter build appbundle --flavor stg --release
```

**Production:**
```bash
flutter build apk --flavor prod --release
flutter build appbundle --flavor prod --release
```

### iOS

iOS requires additional setup in Xcode (see iOS Setup section below).

## iOS Setup

### Step 1: Create Build Configurations

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** project in the Project Navigator
3. Select the **Runner** target
4. Go to **Info** tab
5. Under **Configurations**, duplicate the existing configurations:
   - Duplicate **Debug** → Rename to **Debug-dev**
   - Duplicate **Debug** → Rename to **Debug-stg**
   - Duplicate **Release** → Rename to **Release-dev**
   - Duplicate **Release** → Rename to **Release-stg**
   - Keep **Debug** and **Release** for prod

### Step 2: Create Schemes

1. In Xcode, go to **Product** → **Scheme** → **Manage Schemes**
2. Create three schemes:
   - **dev**: Uses Debug-dev and Release-dev configurations
   - **stg**: Uses Debug-stg and Release-stg configurations
   - **prod**: Uses Debug and Release configurations

### Step 3: Add Preprocessor Macros

For each configuration, add preprocessor macros:

1. Select **Runner** target → **Build Settings**
2. Search for **Swift Compiler - Custom Flags** → **Other Swift Flags**
3. Add flags for each configuration:
   - **Debug-dev**: Add `-D DEV`
   - **Debug-stg**: Add `-D STG`
   - **Release-dev**: Add `-D DEV`
   - **Release-stg**: Add `-D STG`
   - **Debug** (prod): Add `-D PROD`
   - **Release** (prod): Add `-D PROD`

### Step 4: Update Bundle Identifier (Optional)

For each scheme, you can set different bundle identifiers:

1. Select **Runner** target → **Build Settings**
2. Search for **Product Bundle Identifier**
3. Set different identifiers:
   - **dev**: `com.example.personal_finance.dev`
   - **stg**: `com.example.personal_finance.stg`
   - **prod**: `com.example.personal_finance`

### Step 5: Update Info.plist Display Name

Create separate Info.plist files or use build settings:

1. Select **Runner** target → **Info** tab
2. Add **Bundle display name** for each configuration:
   - **dev**: `Personal Finance Dev`
   - **stg**: `Personal Finance Stg`
   - **prod**: `Personal Finance`

### Running iOS Flavors

After setup, run:
```bash
flutter run --flavor dev -t lib/main.dart --debug
flutter run --flavor stg -t lib/main.dart --debug
flutter run --flavor prod -t lib/main.dart --release
```

Or specify the scheme:
```bash
flutter run --flavor dev --debug --ios-scheme dev
```

## Environment-Specific Configuration

Each flavor uses different configuration values defined in `lib/core/config/app_config.dart`:

### Development (dev)
- App Name: "Personal Finance (Dev)"
- API URL: `http://localhost:3000/api`
- Logging: Enabled
- Crash Reporting: Disabled

### Staging (stg)
- App Name: "Personal Finance (Stg)"
- API URL: `https://api-stg.example.com/api`
- Logging: Enabled
- Crash Reporting: Enabled

### Production (prod)
- App Name: "Personal Finance"
- API URL: `https://api.example.com/api`
- Logging: Disabled
- Crash Reporting: Enabled

## Updating Configuration

To update environment-specific values, edit `lib/core/config/app_config.dart`:

```dart
static const AppConfig dev = AppConfig(
  appName: 'Your App Name (Dev)',
  apiBaseUrl: 'https://your-dev-api.com/api',
  environment: 'dev',
  enableLogging: true,
  enableCrashReporting: false,
);
```

## Accessing Configuration in Code

```dart
import 'package:personal_finance/core/config/env_config.dart';

// Get current environment
final isDev = EnvConfig.isDev;
final isStg = EnvConfig.isStg;
final isProd = EnvConfig.isProd;

// Get configuration
final apiUrl = EnvConfig.config.apiBaseUrl;
final appName = EnvConfig.config.appName;
```

## Troubleshooting

### Android: "Flavor not found"
- Make sure you've run `flutter pub get`
- Check that flavors are defined in `android/app/build.gradle.kts`

### iOS: "Scheme not found"
- Make sure you've created the schemes in Xcode
- Verify the scheme names match: dev, stg, prod

### Flavor not detected in app
- Check that `FlavorHelper.initialize()` is called in `main.dart`
- Verify method channel is set up correctly in MainActivity (Android) and AppDelegate (iOS)

## Notes

- Each flavor can be installed simultaneously on a device (different package IDs)
- Dev and Stg flavors have `.dev` and `.stg` suffixes in their package names
- Production flavor uses the base package name
- Remember to update API URLs in `app_config.dart` with your actual backend URLs
