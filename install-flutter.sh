#!/bin/bash

# Install Flutter for Netlify builds
echo "Installing Flutter..."

# Create directory and download Flutter
mkdir -p $HOME/flutter
cd $HOME
wget -O flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz
tar xf flutter.tar.xz
rm flutter.tar.xz

# Add Flutter to PATH for the build process
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation and enable web
$HOME/flutter/bin/flutter doctor -v
$HOME/flutter/bin/flutter config --enable-web

echo "Flutter installation complete!"
