# FocusFlow - Deployment Guide

## 🌐 How to Make Your App Live (So Anyone Can See It)

Your Flutter app is now built and ready to deploy! Here are the best options:

---

## ✅ Option 1: Firebase Hosting (Recommended - FREE)

**Best for:** Quick deployment, free hosting, automatic HTTPS

### Steps:

1. **Install Firebase CLI** (if not installed):
```bash
npm install -g firebase-tools
```

2. **Login to Firebase**:
```bash
firebase login
```

3. **Initialize Firebase Hosting**:
```bash
firebase init hosting
```

When prompted:
- Select your Firebase project: `focus-timer-app-4a5c4`
- Public directory: `build/web`
- Configure as single-page app: `Yes`
- Set up automatic builds: `No`
- Overwrite index.html: `No`

4. **Deploy to Firebase**:
```bash
firebase deploy --only hosting
```

5. **Your Live URL**:
```
https://focus-timer-app-4a5c4.web.app
```

**✅ Done! Share this URL with anyone!**

---

## ✅ Option 2: GitHub Pages (FREE)

**Best for:** Open source projects, version control

### Steps:

1. **Create GitHub Repository**:
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/focusflow.git
git push -u origin main
```

2. **Install gh-pages package**:
```bash
npm install -g gh-pages
```

3. **Deploy to GitHub Pages**:
```bash
cd build/web
git init
git add .
git commit -m "Deploy"
git branch -M gh-pages
git remote add origin https://github.com/YOUR_USERNAME/focusflow.git
git push -f origin gh-pages
```

4. **Enable GitHub Pages**:
- Go to your repo → Settings → Pages
- Source: `gh-pages` branch
- Save

5. **Your Live URL**:
```
https://YOUR_USERNAME.github.io/focusflow
```

---

## ✅ Option 3: Netlify (FREE)

**Best for:** Drag-and-drop deployment, custom domains

### Steps:

1. **Go to Netlify**: https://www.netlify.com
2. **Sign up** (free account)
3. **Drag & Drop** the `build/web` folder
4. **Your Live URL**: `https://random-name.netlify.app`
5. **Optional**: Add custom domain

---

## ✅ Option 4: Vercel (FREE)

**Best for:** Fast deployment, automatic HTTPS

### Steps:

1. **Install Vercel CLI**:
```bash
npm install -g vercel
```

2. **Deploy**:
```bash
cd build/web
vercel
```

3. **Follow prompts** and get your live URL

---

## 📱 Option 5: Mobile App Stores

### Android (Google Play Store)

1. **Build APK**:
```bash
flutter build apk --release
```

2. **Build App Bundle** (recommended):
```bash
flutter build appbundle --release
```

3. **Upload to Google Play Console**:
- Create developer account ($25 one-time fee)
- Upload `build/app/outputs/bundle/release/app-release.aab`
- Fill in app details
- Submit for review

**Your Live URL**: 
```
https://play.google.com/store/apps/details?id=com.example.focusflow
```

### iOS (Apple App Store)

1. **Build iOS App**:
```bash
flutter build ios --release
```

2. **Open in Xcode**:
```bash
open ios/Runner.xcworkspace
```

3. **Archive and Upload**:
- Product → Archive
- Upload to App Store Connect
- Submit for review

**Requirements**:
- Apple Developer Account ($99/year)
- Mac with Xcode

---

## 🚀 Quick Deploy Commands

### Firebase Hosting (Fastest):
```bash
# One-time setup
npm install -g firebase-tools
firebase login
firebase init hosting

# Deploy
flutter build web --release
firebase deploy --only hosting
```

### Netlify (Easiest):
1. Go to https://app.netlify.com/drop
2. Drag `build/web` folder
3. Done!

---

## 🔧 Before Deploying

### 1. Update Firebase Configuration

Make sure your Firebase project allows web domain:
- Go to Firebase Console
- Authentication → Settings → Authorized domains
- Add your deployment domain

### 2. Create Firestore Indexes

Your app needs these indexes (click the links from the error messages):
- Tasks index
- Projects index
- Focus sessions index
- Journal entries index

Or run:
```bash
firebase deploy --only firestore:indexes
```

### 3. Update App Name & Icon

**pubspec.yaml**:
```yaml
name: focusflow
description: "A productivity app to help you focus"
```

**Add app icon** (optional):
```bash
flutter pub add flutter_launcher_icons
```

---

## 📊 Deployment Comparison

| Platform | Cost | Speed | Custom Domain | Best For |
|----------|------|-------|---------------|----------|
| Firebase Hosting | FREE | ⚡⚡⚡ | Yes (free) | Quick deploy |
| GitHub Pages | FREE | ⚡⚡ | Yes (custom) | Open source |
| Netlify | FREE | ⚡⚡⚡ | Yes (free) | Drag & drop |
| Vercel | FREE | ⚡⚡⚡ | Yes (free) | Fast deploy |
| Google Play | $25 | ⚡ | N/A | Android users |
| App Store | $99/year | ⚡ | N/A | iOS users |

---

## 🎯 Recommended Deployment Path

### For Web (Anyone can access via browser):
1. **Build**: `flutter build web --release` ✅ (Already done!)
2. **Deploy**: Use Firebase Hosting (fastest)
3. **Share**: Send URL to anyone

### For Mobile (App stores):
1. **Android**: Build APK → Upload to Play Store
2. **iOS**: Build IPA → Upload to App Store

---

## 🔗 Your Built Files

Your web app is ready in:
```
build/web/
├── index.html
├── main.dart.js
├── flutter.js
├── assets/
└── ...
```

**Size**: ~2-5 MB (optimized)

---

## 📱 Share Your App

Once deployed, share your URL:
- **Web**: `https://your-app.web.app`
- **Android**: `https://play.google.com/store/apps/details?id=...`
- **iOS**: `https://apps.apple.com/app/...`

---

## 🆘 Need Help?

### Common Issues:

**1. Firebase deployment fails**:
```bash
firebase login --reauth
```

**2. App doesn't load**:
- Check Firebase authorized domains
- Clear browser cache

**3. Authentication errors**:
- Add deployment domain to Firebase Auth

**4. Firestore errors**:
- Create required indexes (click error links)

---

## 🎉 Next Steps

1. ✅ Deploy to Firebase Hosting (5 minutes)
2. ✅ Share URL with friends/testers
3. ✅ Collect feedback
4. ✅ Deploy to app stores (optional)

**Your app is ready to go live! 🚀**
