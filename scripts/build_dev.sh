#!/bin/bash

# Build app with dev flavor
echo "Building dev flavor..."

# Android
flutter build apk --flavor dev -t lib/main.dart
# flutter build appbundle --flavor dev -t lib/main.dart

# iOS (uncomment when needed)
# flutter build ios --flavor dev -t lib/main.dart

echo "Build complete!"
