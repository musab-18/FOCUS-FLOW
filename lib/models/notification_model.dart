import 'package:flutter/material.dart';

enum NotificationType {
  taskAdded,
  taskDue,
  taskOverdue,
  focusDone,
  breakDone,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.taskAdded:
        return Icons.add_task_rounded;
      case NotificationType.taskDue:
        return Icons.today_rounded;
      case NotificationType.taskOverdue:
        return Icons.warning_amber_rounded;
      case NotificationType.focusDone:
        return Icons.timer_off_rounded;
      case NotificationType.breakDone:
        return Icons.coffee_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.taskAdded:
        return const Color(0xFF6C63FF);
      case NotificationType.taskDue:
        return const Color(0xFFFF9500);
      case NotificationType.taskOverdue:
        return const Color(0xFFFF3B30);
      case NotificationType.focusDone:
        return const Color(0xFF34C759);
      case NotificationType.breakDone:
        return const Color(0xFF00BCD4);
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
