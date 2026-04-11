import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/focus_session_model.dart';
import '../theme/app_theme.dart';

class AnalyticsProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  List<FocusSessionModel> _sessions = [];
  ThemeMode _themeMode = ThemeMode.system;
  Color _themeColor = AppColors.deepCoral;
  String _language = 'English';
  bool _notificationsEnabled = true;
  bool _isProUser = false;

  ThemeMode get themeMode => _themeMode;
  Color get themeColor => _themeColor;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isProUser => _isProUser;

  void updateData(List<TaskModel> tasks, List<FocusSessionModel> sessions) {
    _tasks = tasks;
    _sessions = sessions;
    notifyListeners();
  }

  // ─── STREAK LOGIC (NEW) ──────────────────────────────────
  int get currentStreak {
    if (_tasks.isEmpty) return 0;
    
    // Get unique dates where at least one task was completed
    final completedDates = _tasks
        .where((t) => t.isCompleted && t.dueDate != null)
        .map((t) => DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day))
        .toSet()
        .toList();

    if (completedDates.isEmpty) return 0;

    // Sort descending (newest first)
    completedDates.sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    // If the latest completion isn't today or yesterday, streak is broken
    if (completedDates.first != todayDate && completedDates.first != yesterdayDate) {
      return 0;
    }

    int streak = 0;
    DateTime currentCheck = completedDates.first;

    for (int i = 0; i < completedDates.length; i++) {
      if (completedDates[i] == currentCheck) {
        streak++;
        currentCheck = currentCheck.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  // ─── WEEKLY BAR CHART DATA ──────────────────────────────
  List<double> get weeklyCompletedTasks {
    final now = DateTime.now();
    final result = List<double>.filled(7, 0);
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: 6 - i));
      result[i] = _tasks.where((t) {
        if (!t.isCompleted || t.dueDate == null) return false;
        final d = t.dueDate!;
        return d.year == day.year && d.month == day.month && d.day == day.day;
      }).length.toDouble();
    }
    return result;
  }

  // ─── 30-DAY LINE CHART DATA ──────────────────────────────
  List<double> get monthlyFocusMinutes {
    final now = DateTime.now();
    final result = List<double>.filled(30, 0);
    for (int i = 0; i < 30; i++) {
      final day = now.subtract(Duration(days: 29 - i));
      final dayMinutes = _sessions
          .where((s) {
            final d = s.startTime;
            return d.year == day.year && d.month == day.month && d.day == day.day;
          })
          .fold<int>(0, (sum, s) => sum + s.durationMinutes);
      result[i] = dayMinutes.toDouble();
    }
    return result;
  }

  // ─── ANALYTICS STATS ─────────────────────────────────────
  int get totalTasksCompleted => _tasks.where((t) => t.isCompleted).length;
  int get totalFocusMinutes =>
      _sessions.fold(0, (sum, s) => sum + s.durationMinutes);
  int get totalPomodoros =>
      _sessions.fold(0, (sum, s) => sum + s.completedPomodoros);

  double get productivityScore {
    if (_tasks.isEmpty) return 0;
    final completionRate = totalTasksCompleted / _tasks.length;
    final focusBonus = (totalFocusMinutes / 60).clamp(0, 10) / 10;
    return ((completionRate * 70) + (focusBonus * 30)).clamp(0, 100);
  }

  Map<String, double> get categoryBreakdown {
    final map = <String, double>{};
    for (final t in _tasks) {
      map[t.categoryId] = (map[t.categoryId] ?? 0) + 1;
    }
    return map;
  }

  // ─── THEME & SETTINGS ────────────────────────────────────
  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('themeMode') ?? 'system';
    _themeMode = themeStr == 'light'
        ? ThemeMode.light
        : themeStr == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;

    final colorVal = prefs.getInt('themeColor');
    if (colorVal != null) {
      _themeColor = Color(colorVal);
    }

    _language = prefs.getString('language') ?? 'English';
    _notificationsEnabled = prefs.getBool('notifications') ?? true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
    notifyListeners();
  }

  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', color.value);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> setNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
    notifyListeners();
  }

  void setProUser(bool isPro) {
    _isProUser = isPro;
    notifyListeners();
  }
}
