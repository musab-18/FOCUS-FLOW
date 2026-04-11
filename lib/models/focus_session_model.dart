import 'package:cloud_firestore/cloud_firestore.dart';

class FocusSessionModel {
  final String id;
  final String userId;
  final String? taskId;
  final DateTime startTime;
  final int durationMinutes;
  final int completedPomodoros;
  final bool isCompleted;

  FocusSessionModel({
    required this.id,
    required this.userId,
    this.taskId,
    required this.startTime,
    required this.durationMinutes,
    this.completedPomodoros = 0,
    this.isCompleted = false,
  });

  factory FocusSessionModel.fromMap(Map<String, dynamic> map) {
    return FocusSessionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      taskId: map['taskId'],
      startTime: (map['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      durationMinutes: map['durationMinutes'] ?? 25,
      completedPomodoros: map['completedPomodoros'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'taskId': taskId,
      'startTime': Timestamp.fromDate(startTime),
      'durationMinutes': durationMinutes,
      'completedPomodoros': completedPomodoros,
      'isCompleted': isCompleted,
    };
  }
}
