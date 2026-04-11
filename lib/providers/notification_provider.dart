import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/notification_model.dart' ;

class NotificationProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;

  /// Prepends a new notification and fires listeners.
  void add({
    required NotificationType type,
    required String title,
    required String body,
  }) {
    _notifications.insert(
      0,
      NotificationModel(
        id: _uuid.v4(),
        type: type,
        title: title,
        body: body,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void markRead(String id) {
    final n = _notifications.where((n) => n.id == id).firstOrNull;
    if (n != null && !n.isRead) {
      n.isRead = true;
      notifyListeners();
    }
  }

  void markAllRead() {
    bool changed = false;
    for (final n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
