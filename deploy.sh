#!/bin/bash

# FocusFlow - Robust Deployment Script
echo "🚀 FocusFlow Deployment Script"
echo "================================"

# 1. Clean old builds
echo "🧹 Cleaning project..."
flutter clean

# 2. Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# 3. Build the web app (Standard Build)
echo "🔨 Building Flutter web app..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"

# 4. Deploy to Firebase
echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting

if [ $? -eq 0 ]; then
    echo "✅ Deployment successful! Your app is updated."
    echo "🌐 URL: https://focus-timer-app-4a5c4.web.app"
else
    echo "❌ Deployment failed!"
    exit 1
fi
