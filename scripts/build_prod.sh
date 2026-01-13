#!/bin/bash

# Build app with prod flavor
echo "Building prod flavor..."

# Android
flutter build apk --flavor prod -t lib/main.dart
# flutter build appbundle --flavor prod -t lib/main.dart

# iOS (uncomment when needed)
# flutter build ios --flavor prod -t lib/main.dart

echo "Build complete!"
