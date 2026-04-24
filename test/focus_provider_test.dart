import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/providers/focus_provider.dart';
import 'package:focusflow/providers/notification_provider.dart';
import 'package:focusflow/providers/analytics_provider.dart';
import 'package:focusflow/models/focus_session_model.dart';
import 'package:focusflow/models/journal_entry_model.dart';
import 'package:focusflow/models/task_model.dart';
import 'package:focusflow/models/category_model.dart';
import 'package:focusflow/models/project_model.dart';
import 'package:focusflow/services/firestore_service.dart';

// Manual Mock to avoid Firebase initialization
class MockFirestoreService implements FirestoreService {
  @override
  Stream<List<TaskModel>> tasksStream(String userId) => Stream.value([]);
  @override
  Stream<List<CategoryModel>> categoriesStream(String userId) => Stream.value([]);
  @override
  Stream<List<ProjectModel>> projectsStream(String userId) => Stream.value([]);
  @override
  Stream<List<FocusSessionModel>> focusSessionsStream(String userId) => Stream.value([]);
  @override
  Stream<List<JournalEntryModel>> journalStream(String userId) => Stream.value([]);
  @override
  Future<void> addTask(TaskModel task) async {}
  @override
  Future<void> updateTask(TaskModel task) async {}
  @override
  Future<void> deleteTask(String taskId) async {}
  @override
  Future<void> addProject(ProjectModel project) async {}
  @override
  Future<void> updateProject(ProjectModel project) async {}
  @override
  Future<void> deleteProject(String projectId) async {}
  @override
  Future<void> addCategory(CategoryModel category) async {}
  @override
  Future<void> deleteCategory(String categoryId) async {}
  @override
  Future<void> addFocusSession(FocusSessionModel session) async {}
  @override
  Future<void> addJournalEntry(JournalEntryModel entry) async {}
  @override
  Future<void> deleteJournalEntry(String id) async {}
  @override
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {}
  @override
  Future<void> changePassword(String newPassword) async {}
}

void main() {
  group('FocusProvider Logic Tests', () {
    late FocusProvider focusProvider;
    late NotificationProvider notificationProvider;
    late AnalyticsProvider analyticsProvider;
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
      focusProvider = FocusProvider(firestoreService: mockFirestoreService);
      notificationProvider = NotificationProvider();
      analyticsProvider = AnalyticsProvider();
      focusProvider.setDependencies(notificationProvider, analyticsProvider);
    });

    test('Initial timer state should be idle', () {
      expect(focusProvider.timerState, TimerState.idle);
      expect(focusProvider.isRunning, false);
    });

    test('startTimer should change state to running', () {
      // Note: startTimer requires a userId to be set to create a sessionId internally, 
      // but the current implementation creates it if _userId is not null.
      // Let's set a fake user ID.
      focusProvider.listenToUser('test_user');
      focusProvider.startTimer();
      expect(focusProvider.timerState, TimerState.running);
      expect(focusProvider.isRunning, true);
    });

    test('pauseTimer should change state to paused', () {
      focusProvider.listenToUser('test_user');
      focusProvider.startTimer();
      focusProvider.pauseTimer();
      expect(focusProvider.timerState, TimerState.paused);
      expect(focusProvider.isRunning, false);
    });

    test('resetTimer should return to idle and reset time', () {
      focusProvider.setWorkDuration(20);
      focusProvider.startTimer();
      focusProvider.resetTimer();
      expect(focusProvider.timerState, TimerState.idle);
      expect(focusProvider.remainingSeconds, 20 * 60);
    });

    test('toggleBlocker should flip isBlockerEnabled', () {
      final initial = focusProvider.isBlockerEnabled;
      focusProvider.toggleBlocker();
      expect(focusProvider.isBlockerEnabled, !initial);
    });
  });
}
