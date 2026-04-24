import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';
import '../models/notification_model.dart';
import '../services/firestore_service.dart';
import 'package:uuid/uuid.dart';
import 'notification_provider.dart';
import 'analytics_provider.dart';

class TaskProvider extends ChangeNotifier {
  final FirestoreService _fs;
  final _uuid = const Uuid();

  List<TaskModel> _tasks = [];
  List<CategoryModel> _categories = [];
  StreamSubscription? _taskSub;
  StreamSubscription? _catSub;
  NotificationProvider? _notificationProvider;
  AnalyticsProvider? _analyticsProvider;
  
  String? _currentUserId;

  TaskProvider({FirestoreService? firestoreService}) : _fs = firestoreService ?? FirestoreService();

  void setDependencies(NotificationProvider np, AnalyticsProvider ap) {
    _notificationProvider = np;
    _analyticsProvider = ap;
  }

  List<TaskModel> get tasks => _tasks;
  List<CategoryModel> get categories => _categories;
  List<TaskModel> get pendingTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<TaskModel> get completedTasks => _tasks.where((t) => t.isCompleted).toList();
  
  List<TaskModel> get todayTasks {
    final today = DateTime.now();
    return _tasks.where((t) {
      if (t.dueDate == null) {
        return t.createdAt.year == today.year && 
               t.createdAt.month == today.month && 
               t.createdAt.day == today.day;
      }
      final d = t.dueDate!;
      return d.year == today.year && d.month == today.month && d.day == today.day;
    }).toList();
  }

  double get todayProgress {
    final today = todayTasks;
    if (today.isEmpty) return 0;
    return today.where((t) => t.isCompleted).length / today.length;
  }

  void listenToUser(String userId) {
    if (_currentUserId == userId) return;
    
    _currentUserId = userId;
    _stopInternal();

    _taskSub = _fs.tasksStream(userId).listen((tasks) {
      _tasks = tasks;
      _analyticsProvider?.updateTasks(tasks);
      notifyListeners();
    }, onError: (e) => debugPrint('Firestore Task Stream Error: $e'));

    _catSub = _fs.categoriesStream(userId).listen((cats) {
      _categories = cats.isEmpty ? CategoryModel.defaults : cats;
      notifyListeners();
    }, onError: (e) => debugPrint('Firestore Category Stream Error: $e'));
  }

  void stopListening() {
    _currentUserId = null;
    _tasks = [];
    _categories = [];
    _stopInternal();
    notifyListeners();
  }

  void _stopInternal() {
    _taskSub?.cancel();
    _catSub?.cancel();
  }

  Future<TaskModel> createTask({
    required String title,
    required String userId,
    String description = '',
    TaskPriority priority = TaskPriority.medium,
    String categoryId = 'personal',
    String? projectId,
    DateTime? dueDate,
    List<SubTask> subTasks = const [],
  }) async {
    final task = TaskModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      userId: userId,
      createdAt: DateTime.now(),
      categoryId: categoryId,
      projectId: projectId,
      dueDate: dueDate,
      subTasks: subTasks,
    );

    _tasks.insert(0, task);
    _analyticsProvider?.updateTasks(_tasks);
    notifyListeners();

    _notificationProvider?.add(
      type: NotificationType.taskAdded,
      title: 'Task Created ⚡',
      body: 'Started: "$title"',
    );

    await _fs.addTask(task);
    return task;
  }

  Future<void> updateTask(TaskModel task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _analyticsProvider?.updateTasks(_tasks);
      notifyListeners();
    }
    await _fs.updateTask(task);
  }

  Future<void> toggleTaskComplete(TaskModel task) async {
    final updated = task.copyWith(
      status: task.isCompleted ? TaskStatus.pending : TaskStatus.completed,
    );
    
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updated;
      _analyticsProvider?.updateTasks(_tasks);
      notifyListeners();
    }

    if (updated.isCompleted) {
       _notificationProvider?.add(
        type: NotificationType.taskAdded,
        title: 'Task Completed! 🎉',
        body: 'Well done: "${task.title}"',
      );
    }
    await _fs.updateTask(updated);
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    _analyticsProvider?.updateTasks(_tasks);
    notifyListeners();
    await _fs.deleteTask(taskId);
  }

  List<TaskModel> getTasksByProject(String projectId) =>
      _tasks.where((t) => t.projectId == projectId).toList();

  List<TaskModel> getTasksByCategory(String categoryId) =>
      _tasks.where((t) => t.categoryId == categoryId).toList();

  List<TaskModel> searchTasks(String query) {
    final q = query.toLowerCase();
    return _tasks
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q))
        .toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _fs.addCategory(category);
  }

  Future<void> deleteCategory(String id) async {
    await _fs.deleteCategory(id);
  }

  @override
  void dispose() {
    _stopInternal();
    super.dispose();
  }
}
