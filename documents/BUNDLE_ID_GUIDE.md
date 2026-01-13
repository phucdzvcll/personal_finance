# Bundle Identifier Guide

## Current Bundle Identifiers

The project uses the following bundle identifiers:

- **Base**: `com.personalfinance.app`
- **Dev**: `com.personalfinance.app.dev`
- **Staging**: `com.personalfinance.app.stg`
- **Production**: `com.personalfinance.app`

## Customizing Bundle Identifier

If you want to use your own bundle identifier (recommended for production):

### Option 1: Use Your Own Domain (Recommended)

Replace `com.personalfinance.app` with your own reverse domain notation:

**Example:**
- If you own `mycompany.com`, use: `com.mycompany.personalfinance`
- Dev: `com.mycompany.personalfinance.dev`
- Staging: `com.mycompany.personalfinance.stg`
- Production: `com.mycompany.personalfinance`

### Option 2: Use Your Name/Organization

**Example:**
- `io.yourname.personalfinance`
- Dev: `io.yourname.personalfinance.dev`
- Staging: `io.yourname.personalfinance.stg`
- Production: `io.yourname.personalfinance`

## How to Change Bundle Identifier

### iOS

1. Open Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Select **Runner** project → **Runner** target

3. Go to **General** tab (or **Build Settings**)

4. Update **Bundle Identifier** for each configuration:
   - Debug: Your base bundle ID
   - Release: Your base bundle ID
   - Debug-dev: Your base bundle ID + `.dev`
   - Release-dev: Your base bundle ID + `.dev`
   - Debug-stg: Your base bundle ID + `.stg`
   - Release-stg: Your base bundle ID + `.stg`

### Android

Edit `android/app/build.gradle.kts`:

```kotlin
productFlavors {
    create("dev") {
        applicationId = "com.yourcompany.personalfinance.dev"
        // ...
    }
    create("stg") {
        applicationId = "com.yourcompany.personalfinance.stg"
        // ...
    }
    create("prod") {
        applicationId = "com.yourcompany.personalfinance"
        // ...
    }
}
```

### Update Method Channel Name

If you change the bundle identifier, also update the method channel name in:

- `ios/Runner/AppDelegate.swift` - Update the channel name
- `android/app/src/main/kotlin/.../MainActivity.kt` - Update the channel name

**Current:**
```swift
let flavorChannel = FlutterMethodChannel(name: "com.example.personal_finance/flavor", ...)
```

**Should be:**
```swift
let flavorChannel = FlutterMethodChannel(name: "com.personalfinance.app/flavor", ...)
```

## Important Notes

1. **Bundle identifiers must be unique** - Apple/Google won't allow duplicate bundle IDs
2. **Use reverse domain notation** - `com.company.app` format
3. **Keep it consistent** - Use the same base ID across iOS and Android
4. **Test before production** - Make sure your bundle ID is available

## Troubleshooting

### "Bundle identifier cannot be registered"

- The bundle ID is already taken
- Use a more unique identifier
- Add your company/name to make it unique

### "No profiles found"

- Make sure you've enabled "Automatically manage signing" in Xcode
- Select your development team
- Xcode will create provisioning profiles automatically

### Multiple Apps on Same Device

Different flavors can coexist on the same device because they have different bundle IDs:
- Dev: `com.personalfinance.app.dev`
- Stg: `com.personalfinance.app.stg`
- Prod: `com.personalfinance.app`
