#!/bin/bash

# Download Flutter SDK
git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter_sdk
export PATH="$PATH:`pwd`/flutter_sdk/bin"

# Check Flutter version
flutter --version

# Enable web support
flutter config --enable-web

# Get packages
flutter pub get

# Build web with base-href set to / for proper asset loading
flutter build web --release --base-href=/

# Fix permissions for web assets
chmod -R 755 build/web/ 