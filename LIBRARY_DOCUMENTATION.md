# FocusFlow - Library Documentation

## 📱 Application Overview

**FocusFlow** is a comprehensive productivity and focus management application built with Flutter. It helps users manage tasks, track focus sessions using the Pomodoro technique, analyze productivity patterns, and maintain focus through distraction blocking and ambient sounds.

**Tech Stack:**
- Flutter SDK 3.10.8+
- Firebase (Authentication, Firestore)
- Provider (State Management)
- Material Design 3

---

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── firebase_options.dart        # Firebase configuration
├── models/                      # Data models
├── providers/                   # State management
├── screens/                     # UI screens
├── services/                    # Business logic & API
├── theme/                       # App theming
└── widgets/                     # Reusable UI components
```

---

## 🗂️ Folder Breakdown

### 1. **models/** - Data Models
Data structures representing the core entities in the app.

| File | Purpose |
|------|---------|
| `task_model.dart` | Task entity with priority, status, subtasks, reminders |
| `project_model.dart` | Project entity with tasks, progress tracking, deadlines |
| `user_model.dart` | User profile with stats (streak, tasks completed, focus minutes) |
| `focus_session_model.dart` | Focus/Pomodoro session tracking |
| `journal_entry_model.dart` | Daily journal entries for reflection |
| `notification_model.dart` | In-app notification data |
| `category_model.dart` | Task categories (Work, Personal, etc.) |

**Key Enums:**
- `TaskPriority`: high, medium, low
- `TaskStatus`: pending, inProgress, completed

---

### 2. **providers/** - State Management
Provider classes managing app state and business logic.

| File | Purpose |
|------|---------|
| `auth_provider.dart` | Authentication state (login, signup, logout) |
| `task_provider.dart` | Task CRUD operations, filtering, Firestore sync |
| `project_provider.dart` | Project management, task aggregation |
| `focus_provider.dart` | Pomodoro timer, focus session tracking |
| `analytics_provider.dart` | User statistics, theme preferences, productivity metrics |
| `notification_provider.dart` | In-app notifications, reminders |

**State Management Pattern:**
- Uses `ChangeNotifierProvider` from the `provider` package
- Real-time Firestore listeners for data synchronization
- Providers initialized in `main.dart` with `MultiProvider`

---

### 3. **screens/** - UI Screens
All user-facing screens organized by feature category.

#### 🔐 **Onboarding & Authentication** (5 screens)

| Screen | Route | Purpose |
|--------|-------|---------|
| `splash_screen.dart` | `/` | App launch screen, checks auth state |
| `onboarding_screen.dart` | `/onboarding` | First-time user tutorial/welcome |
| `login_screen.dart` | `/login` | Email/password login |
| `signup_screen.dart` | `/signup` | New user registration |
| `forgot_password_screen.dart` | `/forgot-password` | Password reset via email |

---

#### 🏠 **Dashboard & Navigation** (4 screens)

| Screen | Route | Purpose |
|--------|-------|---------|
| `home_screen.dart` | `/home` | Main dashboard with task overview, quick stats |
| `calendar_screen.dart` | `/calendar` | Calendar view of tasks and deadlines |
| `search_screen.dart` | `/search` | Global search for tasks, projects |
| `notification_screen.dart` | `/notifications` | In-app notification center |

---

#### ✅ **Task Management** (6 screens)

| Screen | Route | Purpose |
|--------|-------|---------|
| `project_list_screen.dart` | `/projects` | List all projects with progress |
| `task_list_screen.dart` | `/task-list` | View tasks (filtered by project/category) |
| `task_detail_screen.dart` | `/task-detail` | Detailed task view with subtasks |
| `create_edit_task_screen.dart` | `/create-task` | Create or edit tasks |
| `category_manager_screen.dart` | `/categories` | Manage task categories |
| `completed_tasks_screen.dart` | `/completed-tasks` | Archive of completed tasks |

**Features:**
- Task priorities (High, Medium, Low)
- Subtasks with progress tracking
- Due dates and reminders
- Project assignment
- Category tagging

---

#### 🎯 **Focus & Productivity** (5 screens)

| Screen | Route | Purpose |
|--------|-------|---------|
| `pomodoro_screen.dart` | `/pomodoro` | Pomodoro timer (25min work, 5min break) |
| `focus_summary_screen.dart` | `/focus-summary` | Focus session history and stats |
| `distraction_blocker_screen.dart` | `/distraction-blocker` | Block distracting apps/websites |
| `journal_screen.dart` | `/journal` | Daily reflection journal |
| `ambient_player_screen.dart` | `/ambient-player` | Background sounds (rain, cafe, etc.) |

**Pomodoro Technique:**
- 25-minute focus sessions
- 5-minute short breaks
- 15-minute long breaks after 4 pomodoros
- Session tracking and statistics

---

#### 📊 **Analytics & Reports** (2 screens)

| Screen | Route | Purpose |
|--------|-------|---------|
| `activity_dashboard_screen.dart` | `/analytics` | Productivity charts, heatmaps, trends |
| `weekly_report_screen.dart` | `/weekly-report` | Weekly summary of tasks and focus time |

**Analytics Features:**
- Task completion trends
- Focus time tracking
- Productivity heatmaps
- Streak tracking
- Goal progress

---

#### 👤 **Profile & Settings** (4 screens)

| Screen | Route | Purpose |
|--------|-------|---------|
| `profile_screen.dart` | `/profile` | User profile, stats, badges |
| `settings_screen.dart` | `/settings` | App preferences, theme, notifications |
| `subscription_screen.dart` | `/subscription` | Premium features, billing |
| `help_feedback_screen.dart` | `/help` | Help docs, contact support |

---

### 4. **services/** - Business Logic Layer

| File | Purpose |
|------|---------|
| `auth_service.dart` | Firebase Authentication wrapper (login, signup, logout) |
| `firestore_service.dart` | Firestore CRUD operations, queries |

**Service Pattern:**
- Separates Firebase logic from UI
- Provides clean API for providers
- Handles error cases and exceptions

---

### 5. **theme/** - App Theming

| File | Purpose |
|------|---------|
| `app_theme.dart` | Light/dark themes, color schemes, typography |

**Theme Features:**
- Material Design 3
- Dynamic color theming
- Light and dark mode support
- Custom color palettes
- Inter font family (bundled)

---

### 6. **widgets/** - Reusable Components

| File | Purpose |
|------|---------|
| `task_card.dart` | Task list item with priority badge, progress |
| `project_card.dart` | Project card with progress ring |
| `custom_text_field.dart` | Styled text input field |
| `loading_overlay.dart` | Full-screen loading indicator |
| `priority_badge.dart` | Color-coded priority indicator |
| `progress_ring.dart` | Circular progress indicator |

---

## 🔥 Firebase Integration

### Authentication
- Email/password authentication
- Password reset via email
- Session persistence (LOCAL mode for macOS compatibility)

### Firestore Collections
```
users/
  └── {userId}/
      ├── tasks/
      ├── projects/
      ├── focusSessions/
      ├── journalEntries/
      └── notifications/
```

### Real-time Listeners
- Tasks sync automatically across devices
- Projects update when tasks change
- Focus sessions tracked in real-time

---

## 🎨 Design System

### Color Palette
- Primary: Dynamic (user-selectable)
- Surface: White (light) / Dark gray (dark)
- Text: High contrast for accessibility

### Typography
- Font: Inter (Regular, Medium, SemiBold, Bold, ExtraBold)
- Bundled locally (no network fetching)

### Components
- Material Design 3 components
- Custom widgets for consistency
- Responsive layouts

---

## 🚀 App Flow

### First Launch
1. **Splash Screen** → Check auth state
2. **Onboarding Screen** → Tutorial (first-time users)
3. **Login/Signup** → Authentication
4. **Home Screen** → Main dashboard

### Authenticated Flow
```
Home Screen (Bottom Nav)
├── Home Tab (Tasks overview)
├── Calendar Tab
├── Analytics Tab
└── Profile Tab

Floating Action Button → Quick Add Task
```

### Task Workflow
1. Create task → Set priority, due date, category
2. Assign to project (optional)
3. Add subtasks (optional)
4. Start focus session (Pomodoro)
5. Mark complete → Track in analytics

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | User authentication |
| `cloud_firestore` | NoSQL database |
| `provider` | State management |
| `fl_chart` | Charts and graphs |
| `google_fonts` | Typography |
| `table_calendar` | Calendar widget |
| `intl` | Date/time formatting |
| `shared_preferences` | Local storage |
| `uuid` | Unique ID generation |

---

## 🔒 Security Features

- Firebase Authentication with email verification
- Firestore security rules (user-scoped data)
- Local session persistence
- Password reset functionality

---

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Web
- ❌ Windows (not configured)
- ❌ Linux (not configured)

---

## 🎯 Core Features Summary

### Task Management
- Create, edit, delete tasks
- Priority levels and status tracking
- Subtasks with progress
- Due dates and reminders
- Project organization
- Category tagging

### Focus Tools
- Pomodoro timer with customizable intervals
- Focus session tracking
- Distraction blocker
- Ambient sound player
- Daily journal for reflection

### Analytics
- Task completion trends
- Focus time statistics
- Productivity heatmaps
- Weekly/monthly reports
- Streak tracking
- Achievement badges

### Personalization
- Light/dark theme
- Custom color schemes
- Notification preferences
- Profile customization

---

## 🛠️ Development Notes

### State Management
- Uses Provider pattern
- Firestore listeners in providers
- AuthWrapper ensures authenticated access
- Listeners start once per user session

### Navigation
- Named routes in `main.dart`
- AuthWrapper protects authenticated routes
- Bottom navigation for main tabs
- Floating action button for quick actions

### Data Persistence
- Firestore for cloud sync
- SharedPreferences for local settings
- Real-time updates across devices

---

## 📝 File Naming Conventions

- **Screens**: `{feature}_screen.dart` (e.g., `home_screen.dart`)
- **Models**: `{entity}_model.dart` (e.g., `task_model.dart`)
- **Providers**: `{feature}_provider.dart` (e.g., `auth_provider.dart`)
- **Services**: `{feature}_service.dart` (e.g., `auth_service.dart`)
- **Widgets**: `{component}_widget.dart` or descriptive name

---

## 🎓 Learning Resources

### Understanding the Codebase
1. Start with `main.dart` - app initialization
2. Review `models/` - understand data structures
3. Explore `providers/` - state management logic
4. Navigate `screens/` - UI implementation
5. Check `services/` - Firebase integration

### Key Concepts
- **Provider Pattern**: State management across widgets
- **Firestore Listeners**: Real-time data synchronization
- **Material Design 3**: Modern UI components
- **Pomodoro Technique**: Time management methodology

---

## 📞 Support & Feedback

Users can access help through:
- `help_feedback_screen.dart` - In-app support
- Settings screen - App preferences
- Profile screen - Account management

---

**Last Updated**: April 11, 2026
**Version**: 1.0.0+1
**Flutter SDK**: 3.10.8+
