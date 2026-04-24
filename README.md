# 🚀 FocusFlow

[![Flutter CI](https://github.com/musab-18/FOCUS-FLOW/actions/workflows/main.yml/badge.svg)](https://github.com/musab-18/FOCUS-FLOW/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web-blue)](https://flutter.dev)

**FocusFlow** is a professional-grade productivity ecosystem designed to help users master their time, track progress, and stay motivated. Built with modern Flutter architecture and a focus on high-performance rendering and security.

---

## ✨ Key Features

### 📅 Smart Task Management
- **Adaptive Grid/List Views**: UI dynamically adjusts for Phones, Tablets, and Desktop.
- **Categorization**: Organize your life with custom categories and projects.
- **Progress Tracking**: Real-time completion rings and daily stats.

### ⏱️ Deep Work & Pomodoro
- **Focus Timer**: Integrated Pomodoro timer with customizable work/break intervals.
- **Distraction Blocker**: Dedicated focus mode to keep you on track.
- **Ambient Player**: (Ready for integration) Curated sounds for deep work sessions.

### 📓 Mindful Journaling
- **Motivational Library**: Built-in guides on deep focus and overcoming procrastination.
- **Smart Prompts**: Quick-fill motivational prompts to kickstart your daily reflection.
- **Mood Tracking**: Log your emotional state alongside your productivity.

### 📊 Advanced Analytics
- **Streak Logic**: Professional-grade streak tracking to build consistent habits.
- **Productivity Scoring**: Complex algorithms that calculate scores based on focus time and task completion.
- **Visual Charts**: Monthly and weekly breakdowns using `fl_chart`.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (v3.10.8+)
- **State Management**: [Provider](https://pub.dev/packages/provider) (Clean Logic-UI separation)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Cloud Firestore, Crashlytics)
- **Security**: 
  - `flutter_secure_storage` for sensitive tokens.
  - Environment variables via `.env` (No hardcoded API keys).
- **QA & Testing**: 
  - Unit Tests for business logic (Streaks, Scoring).
  - Global Error Boundaries to prevent crashes.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed.
- Firebase project configured.

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/musab-18/FOCUS-FLOW.git
   cd FOCUS-FLOW
   ```

2. **Configure Environment Variables**
   Create a `.env` file in the root directory and add your Firebase credentials:
   ```env
   FIREBASE_API_KEY_ANDROID=your_key
   FIREBASE_APP_ID_ANDROID=your_id
   FIREBASE_API_KEY_IOS=your_key
   FIREBASE_APP_ID_IOS=your_id
   FIREBASE_API_KEY_WEB=your_key
   FIREBASE_APP_ID_WEB=your_id
   FIREBASE_PROJECT_ID=your_project_id
   FIREBASE_MESSAGING_SENDER_ID=your_id
   FIREBASE_STORAGE_BUCKET=your_bucket
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the App**
   ```bash
   # Standard Run
   flutter run

   # Release Build (with Obfuscation)
   flutter build apk --obfuscate --split-debug-info=./debug-info
   ```

---

## 🧪 Testing & CI/CD

This project uses **GitHub Actions** to ensure stability.
- **Automated Tests**: Every push triggers a suite of unit tests.
- **Build Verification**: Ensures the project is always in a release-ready state.

To run tests locally:
```bash
flutter test test/analytics_test.dart
```

---

## 📱 Adaptive UI Preview

| Mobile View | Desktop View |
| :---: | :---: |
| Centered vertical stack for focus | Wide-screen optimized 2-column grid |
| Optimized for one-hand usage | Professional dashboard layout |

---

## 📄 License
Distributed under the MIT License. See `LICENSE` for more information.

---

## 👤 Author
**Musab**
- GitHub: [@musab-18](https://github.com/musab-18)

---
*If you like this project, please give it a ⭐ on GitHub!*
