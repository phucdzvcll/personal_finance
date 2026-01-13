#!/bin/bash

# Build app with stg flavor
echo "Building stg flavor..."

# Android
flutter build apk --flavor stg -t lib/main.dart
# flutter build appbundle --flavor stg -t lib/main.dart

# iOS (uncomment when needed)
# flutter build ios --flavor stg -t lib/main.dart

echo "Build complete!"
