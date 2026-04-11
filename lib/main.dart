import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'providers/project_provider.dart';
import 'providers/focus_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/notification_provider.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/search_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/project_list_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/create_edit_task_screen.dart';
import 'screens/category_manager_screen.dart';
import 'screens/completed_tasks_screen.dart';
import 'screens/pomodoro_screen.dart';
import 'screens/focus_summary_screen.dart';
import 'screens/distraction_blocker_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/ambient_player_screen.dart';
import 'screens/activity_dashboard_screen.dart';
import 'screens/weekly_report_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/help_feedback_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Explicitly set Auth persistence
    try {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    } catch (e) {
      debugPrint('Auth Persistence setup failed: $e');
    }
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e');
  }

  runApp(const FocusFlowApp());
}

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => FocusProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()..loadPrefs()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<AnalyticsProvider>(
        builder: (ctx, analytics, _) => MaterialApp(
          title: 'FocusFlow',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getLight(analytics.themeColor),
          darkTheme: AppTheme.getDark(analytics.themeColor),
          themeMode: analytics.themeMode,
          initialRoute: '/',
          routes: {
            '/': (_) => const SplashScreen(),
            '/onboarding': (_) => const OnboardingScreen(),
            '/login': (_) => const LoginScreen(),
            '/signup': (_) => const SignupScreen(),
            '/forgot-password': (_) => const ForgotPasswordScreen(),
            '/home': (_) => const AuthWrapper(child: HomeScreen()),
            '/calendar': (_) => const AuthWrapper(child: CalendarScreen()),
            '/search': (_) => const AuthWrapper(child: SearchScreen()),
            '/notifications': (_) => const AuthWrapper(child: NotificationScreen()),
            '/projects': (_) => const AuthWrapper(child: ProjectListScreen()),
            '/task-list': (_) => const AuthWrapper(child: TaskListScreen()),
            '/task-detail': (_) => const AuthWrapper(child: TaskDetailScreen()),
            '/create-task': (_) => const AuthWrapper(child: CreateEditTaskScreen()),
            '/categories': (_) => const AuthWrapper(child: CategoryManagerScreen()),
            '/completed-tasks': (_) => const AuthWrapper(child: CompletedTasksScreen()),
            '/pomodoro': (_) => const AuthWrapper(child: PomodoroScreen()),
            '/focus-summary': (_) => const AuthWrapper(child: FocusSummaryScreen()),
            '/distraction-blocker': (_) => const AuthWrapper(child: DistractionBlockerScreen()),
            '/journal': (_) => const AuthWrapper(child: JournalScreen()),
            '/ambient-player': (_) => const AuthWrapper(child: AmbientPlayerScreen()),
            '/analytics': (_) => const AuthWrapper(child: ActivityDashboardScreen()),
            '/weekly-report': (_) => const AuthWrapper(child: WeeklyReportScreen()),
            '/goals': (_) => const AuthWrapper(child: ActivityDashboardScreen()),
            '/profile': (_) => const AuthWrapper(child: ProfileScreen()),
            '/settings': (_) => const AuthWrapper(child: SettingsScreen()),
            '/subscription': (_) => const SubscriptionScreen(),
            '/help': (_) => const HelpFeedbackScreen(),
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  final Widget child;
  const AuthWrapper({super.key, required this.child});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? _lastListenedUid;

  void _startListeners(BuildContext context, String uid) {
    if (_lastListenedUid == uid) return; 
    _lastListenedUid = uid;
    
    try {
      final notifProvider = context.read<NotificationProvider>();
      context.read<TaskProvider>()
        ..setNotificationProvider(notifProvider)
        ..listenToUser(uid);
      context.read<FocusProvider>()
        ..setNotificationProvider(notifProvider)
        ..listenToUser(uid);
      context.read<ProjectProvider>().listenToUser(uid);
    } catch (e) {
      debugPrint('Listener Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // RECOVERY LOGIC: If it stays uninitialized for too long, it's likely a Keychain error
    // We show the login screen instead of a blank screen.
    if (!auth.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.redAccent)),
      );
    }

    if (!auth.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        }
      });
      // Fallback UI to prevent blank screen
      return const Scaffold(
        body: Center(child: Text('Connecting to session...')),
      );
    }

    if (auth.user != null) {
      _startListeners(context, auth.user!.uid);
    }

    return widget.child;
  }
}
