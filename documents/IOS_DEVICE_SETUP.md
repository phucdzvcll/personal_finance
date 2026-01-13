# Running on iOS Device - Complete Guide

## Prerequisites

1. **macOS** - Required for iOS development
2. **Xcode** - Install from App Store (latest version recommended)
3. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```
4. **CocoaPods** (if not installed):
   ```bash
   sudo gem install cocoapods
   ```
5. **iOS Device** - iPhone or iPad connected via USB or WiFi

## Quick Start

### Using Makefile (Easiest)

```bash
# List available iOS devices
make devices

# Run on iOS device (dev flavor)
make run-dev

# Run on iOS device (staging flavor)
make run-stg

# Run on iOS device (production flavor)
make run-prod
```

### Using Flutter CLI

```bash
# List connected devices
flutter devices

# Run on iOS device (dev flavor)
flutter run --flavor dev -t lib/main.dart

# Run on iOS device (staging flavor)
flutter run --flavor stg -t lib/main.dart

# Run on iOS device (production flavor)
flutter run --flavor prod -t lib/main.dart
```

## Step-by-Step Setup

### 1. Connect Your iOS Device

1. Connect your iPhone/iPad to your Mac via USB cable
2. Unlock your device
3. Trust the computer if prompted
4. Verify device is detected:
   ```bash
   flutter devices
   ```
   You should see your device listed, e.g.:
   ```
   iPhone 15 Pro (mobile) • 00008030-001A... • ios • iOS 17.0
   ```

### 2. Configure Xcode Signing

**Important:** You need to set up code signing in Xcode before running on a physical device.

1. Open Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
   ⚠️ **Note:** Open `.xcworkspace`, NOT `.xcodeproj`

2. Select the **Runner** project in the left sidebar

3. Select the **Runner** target

4. Go to **Signing & Capabilities** tab

5. Check **"Automatically manage signing"**

6. Select your **Team** (your Apple Developer account)
   - If you don't have one, you can use a free Apple ID
   - Xcode will create a free provisioning profile

7. Set **Bundle Identifier**:
   - Dev: `com.example.personal_finance.dev`
   - Stg: `com.example.personal_finance.stg`
   - Prod: `com.example.personal_finance`

### 3. Trust Developer Certificate on Device

1. On your iOS device, go to **Settings** → **General** → **VPN & Device Management**
2. Tap on your developer certificate
3. Tap **"Trust [Your Name]"**
4. Confirm by tapping **"Trust"**

### 4. Run the App

```bash
# Using Makefile
make run-dev

# Or using Flutter CLI
flutter run --flavor dev -t lib/main.dart
```

## iOS Flavors Setup (Optional but Recommended)

For flavors to work properly on iOS, you need to configure Xcode schemes. This allows different app configurations (dev, stg, prod) to run simultaneously.

### Quick Setup (Simplified)

If you just want to run the app without flavors:

```bash
# Run without specifying flavor (uses default)
flutter run -d <device-id>
```

### Full Flavors Setup

1. **Open Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Create Build Configurations**:
   - Select **Runner** project → **Runner** target → **Info** tab
   - Under **Configurations**, duplicate:
     - **Debug** → **Debug-dev**
     - **Debug** → **Debug-stg**
     - **Release** → **Release-dev**
     - **Release** → **Release-stg**

3. **Create Schemes**:
   - Go to **Product** → **Scheme** → **Manage Schemes**
   - Click **+** to create new schemes:
     - **dev** (uses Debug-dev/Release-dev)
     - **stg** (uses Debug-stg/Release-stg)
     - **prod** (uses Debug/Release)

4. **Add Swift Flags** (for flavor detection):
   - Select **Runner** target → **Build Settings**
   - Search for **"Other Swift Flags"**
   - Add for each configuration:
     - **Debug-dev**: `-D DEV`
     - **Debug-stg**: `-D STG`
     - **Release-dev**: `-D DEV`
     - **Release-stg**: `-D STG`
     - **Debug** (prod): `-D PROD`
     - **Release** (prod): `-D PROD`

5. **Update Bundle Identifiers**:
   - In **Build Settings**, search for **"Product Bundle Identifier"**
   - Set different IDs for each configuration:
     - Dev: `com.example.personal_finance.dev`
     - Stg: `com.example.personal_finance.stg`
     - Prod: `com.example.personal_finance`

## Common Commands

### List Devices
```bash
flutter devices
# or
make devices
```

### Run on Specific Device
```bash
# Get device ID first
flutter devices

# Run on specific device
flutter run -d <device-id> --flavor dev -t lib/main.dart
```

### Run in Release Mode
```bash
flutter run --flavor dev -t lib/main.dart --release
```

### Build for Device (without running)
```bash
flutter build ios --flavor dev -t lib/main.dart
```

## Troubleshooting

### "No devices found"
1. Check USB connection
2. Unlock your device
3. Trust the computer on device
4. Restart Xcode
5. Run `flutter doctor` to check for issues

### "Code signing error"
1. Open Xcode: `open ios/Runner.xcworkspace`
2. Select Runner → Signing & Capabilities
3. Enable "Automatically manage signing"
4. Select your Team
5. Fix any bundle identifier conflicts

### "Unable to install app"
1. Check device storage space
2. Verify device is unlocked
3. Trust developer certificate on device (Settings → General → VPN & Device Management)
4. Try cleaning build: `flutter clean`

### "Scheme not found" (for flavors)
1. Make sure you've created schemes in Xcode
2. Verify scheme names match: dev, stg, prod
3. Try running without flavor first: `flutter run`

### "Pod install" errors
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Build fails with "Command PhaseScriptExecution failed"
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

### App crashes immediately
1. Check Xcode console for errors
2. Verify code signing is correct
3. Check that all dependencies are installed:
   ```bash
   cd ios
   pod install
   cd ..
   ```

## WiFi Debugging (Advanced)

To run without USB cable:

1. Connect device via USB first
2. In Xcode: **Window** → **Devices and Simulators**
3. Select your device
4. Check **"Connect via network"**
5. Disconnect USB cable
6. Device should appear in `flutter devices` with "(wireless)"

## Tips

1. **First Run**: Always run via USB first, then enable WiFi debugging
2. **Hot Reload**: Works on physical devices! Press `r` in terminal or use IDE hot reload
3. **Performance**: Release mode (`--release`) gives better performance
4. **Debugging**: Use Xcode for native iOS debugging, Flutter DevTools for Flutter debugging
5. **Multiple Devices**: You can run on multiple devices simultaneously using device IDs

## Quick Reference

```bash
# Check setup
flutter doctor -v

# List devices
flutter devices

# Run dev flavor
make run-dev

# Run with specific device
flutter run -d <device-id> --flavor dev -t lib/main.dart

# Build iOS
make build-ios-dev

# Clean and rebuild
make clean
make install
make gen
make run-dev
```

## Need Help?

- Run `flutter doctor -v` to diagnose issues
- Check Xcode console for detailed error messages
- Verify your Apple Developer account is properly configured
- Make sure your device iOS version is supported by your Flutter SDK
