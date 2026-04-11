#!/bin/bash

# FocusFlow - Quick Deployment Script
# This script deploys your app to Firebase Hosting

echo "🚀 FocusFlow Deployment Script"
echo "================================"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null
then
    echo "❌ Firebase CLI not found!"
    echo "📦 Installing Firebase CLI..."
    npm install -g firebase-tools
fi

# Build the web app
echo "🔨 Building Flutter web app..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"
echo ""

# Check if Firebase is initialized
if [ ! -f "firebase.json" ]; then
    echo "⚙️  Initializing Firebase..."
    firebase init hosting
fi

# Deploy to Firebase
echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deployment successful!"
    echo "🌐 Your app is now live!"
    echo ""
    echo "📱 Share this URL: https://focus-timer-app-4a5c4.web.app"
    echo ""
else
    echo "❌ Deployment failed!"
    exit 1
fi
