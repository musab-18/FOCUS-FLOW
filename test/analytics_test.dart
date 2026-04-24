import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/providers/analytics_provider.dart';
import 'package:focusflow/models/task_model.dart';
import 'package:focusflow/models/focus_session_model.dart';

void main() {
  group('AnalyticsProvider Logic Tests', () {
    late AnalyticsProvider analytics;

    setUp(() {
      analytics = AnalyticsProvider();
    });

    test('Streak should be 0 when no tasks exist', () {
      analytics.updateData([], []);
      expect(analytics.currentStreak, 0);
    });

    test('Streak should be 1 if one task was completed today', () {
      final today = DateTime.now();
      final List<TaskModel> tasks = [
        TaskModel(
          id: '1', 
          title: 'T1', 
          status: TaskStatus.completed, 
          dueDate: today, 
          categoryId: 'cat1', 
          createdAt: today,
          userId: 'test_user',
        ),
      ];
      analytics.updateData(tasks, []);
      expect(analytics.currentStreak, 1);
    });

    test('Productivity Score should be 100% with all tasks done and 10+ hours focus', () {
      final List<TaskModel> tasks = [
        TaskModel(
          id: '1', 
          title: 'T1', 
          status: TaskStatus.completed, 
          categoryId: 'c1', 
          createdAt: DateTime.now(),
          userId: 'test_user',
        ),
      ];
      final List<FocusSessionModel> sessions = [
        FocusSessionModel(
          id: 's1', 
          userId: 'test_user',
          startTime: DateTime.now(), 
          durationMinutes: 600, // 10 hours to get max focus bonus
          completedPomodoros: 20,
          taskId: '1'
        ),
      ];
      
      analytics.updateData(tasks, sessions);
      // Completion Rate (1.0 * 70) + Focus Bonus (1.0 * 30) = 100
      expect(analytics.productivityScore, 100.0);
    });

    test('Total Focus Minutes should calculate correctly', () {
      final List<FocusSessionModel> sessions = [
        FocusSessionModel(
          id: 's1', 
          userId: 'test_user',
          startTime: DateTime.now(), 
          durationMinutes: 25, 
          completedPomodoros: 1
        ),
        FocusSessionModel(
          id: 's2', 
          userId: 'test_user',
          startTime: DateTime.now(), 
          durationMinutes: 15, 
          completedPomodoros: 0
        ),
      ];
      analytics.updateData([], sessions);
      expect(analytics.totalFocusMinutes, 40);
    });

    test('Category breakdown should count tasks per category', () {
      final List<TaskModel> tasks = [
        TaskModel(
          id: '1', 
          title: 'T1', 
          status: TaskStatus.pending, 
          categoryId: 'work', 
          createdAt: DateTime.now(),
          userId: 'test_user',
        ),
        TaskModel(
          id: '2', 
          title: 'T2', 
          status: TaskStatus.pending, 
          categoryId: 'work', 
          createdAt: DateTime.now(),
          userId: 'test_user',
        ),
        TaskModel(
          id: '3', 
          title: 'T3', 
          status: TaskStatus.pending, 
          categoryId: 'personal', 
          createdAt: DateTime.now(),
          userId: 'test_user',
        ),
      ];
      analytics.updateData(tasks, []);
      expect(analytics.categoryBreakdown['work'], 2);
      expect(analytics.categoryBreakdown['personal'], 1);
    });
  });
}
