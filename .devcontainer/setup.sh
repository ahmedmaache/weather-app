#!/bin/bash
set -e

echo "🚀 Setting up Flutter development environment..."

# Install Flutter
FLUTTER_VERSION="stable"
FLUTTER_SDK="/opt/flutter"

if [ ! -d "$FLUTTER_SDK" ]; then
    echo "📦 Installing Flutter SDK..."
    git clone https://github.com/flutter/flutter.git -b $FLUTTER_VERSION $FLUTTER_SDK
    export PATH="$FLUTTER_SDK/bin:$PATH"
    flutter doctor
    flutter precache
fi

# Install Android SDK
ANDROID_SDK="/opt/android-sdk"
if [ ! -d "$ANDROID_SDK" ]; then
    echo "📦 Installing Android SDK..."
    mkdir -p $ANDROID_SDK
    cd $ANDROID_SDK
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip -q commandlinetools-linux-9477386_latest.zip
    rm commandlinetools-linux-9477386_latest.zip
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
    
    export ANDROID_HOME=$ANDROID_SDK
    export ANDROID_SDK_ROOT=$ANDROID_SDK
    export PATH="$ANDROID_SDK/cmdline-tools/latest/bin:$ANDROID_SDK/platform-tools:$PATH"
    
    yes | sdkmanager --licenses || true
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
fi

# Set environment variables
echo 'export FLUTTER_ROOT=/opt/flutter' >> ~/.bashrc
echo 'export PATH=$FLUTTER_ROOT/bin:$PATH' >> ~/.bashrc
echo 'export ANDROID_HOME=/opt/android-sdk' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT=/opt/android-sdk' >> ~/.bashrc
echo 'export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH' >> ~/.bashrc

# Setup GitHub CLI if token is available
if [ -n "$GITHUB_TOKEN" ]; then
    echo "🔐 Configuring GitHub CLI..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token
fi

echo "✅ Setup complete!"
echo "Run 'flutter doctor' to verify installation"
