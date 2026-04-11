import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { high, medium, low }

enum TaskStatus { pending, inProgress, completed }

class SubTask {
  final String id;
  final String title;
  bool isCompleted;

  SubTask({required this.id, required this.title, this.isCompleted = false});

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
  };
}

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final String categoryId;
  final String? projectId;
  final String userId;
  final DateTime createdAt;
  final DateTime? dueDate;
  final List<SubTask> subTasks;
  final bool hasReminder;
  final DateTime? reminderTime;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.categoryId = 'personal',
    this.projectId,
    required this.userId,
    required this.createdAt,
    this.dueDate,
    this.subTasks = const [],
    this.hasReminder = false,
    this.reminderTime,
  });

  bool get isCompleted => status == TaskStatus.completed;

  int get completedSubTasks => subTasks.where((s) => s.isCompleted).length;

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TaskStatus.pending,
      ),
      categoryId: map['categoryId'] ?? 'personal',
      projectId: map['projectId'],
      userId: map['userId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dueDate: (map['dueDate'] as Timestamp?)?.toDate(),
      subTasks: (map['subTasks'] as List<dynamic>?)
              ?.map((s) => SubTask.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
      hasReminder: map['hasReminder'] ?? false,
      reminderTime: (map['reminderTime'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'categoryId': categoryId,
      'projectId': projectId,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'subTasks': subTasks.map((s) => s.toMap()).toList(),
      'hasReminder': hasReminder,
      'reminderTime': reminderTime != null ? Timestamp.fromDate(reminderTime!) : null,
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    String? categoryId,
    String? projectId,
    DateTime? dueDate,
    List<SubTask>? subTasks,
    bool? hasReminder,
    DateTime? reminderTime,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      projectId: projectId ?? this.projectId,
      userId: userId,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      subTasks: subTasks ?? this.subTasks,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
