#!/bin/bash

# Install Flutter for Netlify builds
echo "Installing Flutter..."

# Download Flutter
cd /opt
wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
tar xf flutter_linux_3.24.3-stable.tar.xz

# Add Flutter to PATH
export PATH="$PATH:/opt/flutter/bin"

# Run flutter doctor and enable web
flutter doctor
flutter config --enable-web

echo "Flutter installation complete!"
