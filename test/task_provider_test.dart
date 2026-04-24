import 'package:flutter_test/flutter_test.dart';
import 'package:focusflow/providers/task_provider.dart';
import 'package:focusflow/providers/notification_provider.dart';
import 'package:focusflow/providers/analytics_provider.dart';
import 'package:focusflow/services/firestore_service.dart';
import 'package:focusflow/models/task_model.dart';
import 'package:focusflow/models/category_model.dart';
import 'package:focusflow/models/project_model.dart';
import 'package:focusflow/models/focus_session_model.dart';
import 'package:focusflow/models/journal_entry_model.dart';

// Use 'implements' to avoid calling the real FirestoreService constructor
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
  group('TaskProvider Tests', () {
    late TaskProvider taskProvider;
    late NotificationProvider notificationProvider;
    late AnalyticsProvider analyticsProvider;
    late MockFirestoreService mockFirestoreService;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
      taskProvider = TaskProvider(firestoreService: mockFirestoreService);
      notificationProvider = NotificationProvider();
      analyticsProvider = AnalyticsProvider();
      taskProvider.setDependencies(notificationProvider, analyticsProvider);
    });

    test('Initial tasks list should be empty', () {
      expect(taskProvider.tasks, isEmpty);
    });

    test('Today progress should be 0 when no tasks', () {
      expect(taskProvider.todayProgress, 0);
    });

    test('searchTasks should filter tasks by title', () {
      expect(taskProvider.searchTasks('any'), isEmpty);
    });
  });
}
