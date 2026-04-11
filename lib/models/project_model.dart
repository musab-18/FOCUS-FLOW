import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String name;
  final String colorHex;
  final String userId;
  final DateTime createdAt;
  final DateTime? deadline;
  final String description;
  final int totalTasks;
  final int completedTasks;

  ProjectModel({
    required this.id,
    required this.name,
    this.colorHex = '#FF5A5F',
    required this.userId,
    required this.createdAt,
    this.deadline,
    this.description = '',
    this.totalTasks = 0,
    this.completedTasks = 0,
  });

  double get progress =>
      totalTasks == 0 ? 0 : completedTasks / totalTasks;

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      colorHex: map['colorHex'] ?? '#FF5A5F',
      userId: map['userId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deadline: (map['deadline'] as Timestamp?)?.toDate(),
      description: map['description'] ?? '',
      totalTasks: map['totalTasks'] ?? 0,
      completedTasks: map['completedTasks'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'description': description,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
    };
  }

  ProjectModel copyWith({
    String? name,
    String? colorHex,
    DateTime? deadline,
    String? description,
    int? totalTasks,
    int? completedTasks,
  }) {
    return ProjectModel(
      id: id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      userId: userId,
      createdAt: createdAt,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}
