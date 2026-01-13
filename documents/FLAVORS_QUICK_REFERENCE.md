# Flavors Quick Reference

## Quick Commands

### Run
```bash
# Development
flutter run --flavor dev -t lib/main.dart

# Staging  
flutter run --flavor stg -t lib/main.dart

# Production
flutter run --flavor prod -t lib/main.dart
```

### Build Android APK
```bash
flutter build apk --flavor dev --release
flutter build apk --flavor stg --release
flutter build apk --flavor prod --release
```

### Build Android App Bundle
```bash
flutter build appbundle --flavor dev --release
flutter build appbundle --flavor stg --release
flutter build appbundle --flavor prod --release
```

## Using Scripts

```bash
./scripts/run_dev.sh      # Run dev
./scripts/run_stg.sh       # Run stg
./scripts/run_prod.sh      # Run prod

./scripts/build_dev.sh     # Build dev APK
./scripts/build_stg.sh     # Build stg APK
./scripts/build_prod.sh   # Build prod APK
```

## VS Code

Use the launch configurations in `.vscode/launch.json`:
- Press `F5` or go to Run → Start Debugging
- Select the flavor you want to run

## Environment Configuration

Edit `lib/core/config/app_config.dart` to update:
- API URLs
- App names
- Feature flags (logging, crash reporting)

## Package IDs

- **Dev**: `com.example.personal_finance.dev`
- **Stg**: `com.example.personal_finance.stg`
- **Prod**: `com.example.personal_finance`

All three can be installed simultaneously on the same device!
