import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime joinedAt;
  final int streakDays;
  final int tasksCompleted;
  final int focusMinutes;
  final List<String> badges;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.joinedAt,
    this.streakDays = 0,
    this.tasksCompleted = 0,
    this.focusMinutes = 0,
    this.badges = const [],
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      streakDays: map['streakDays'] ?? 0,
      tasksCompleted: map['tasksCompleted'] ?? 0,
      focusMinutes: map['focusMinutes'] ?? 0,
      badges: List<String>.from(map['badges'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'streakDays': streakDays,
      'tasksCompleted': tasksCompleted,
      'focusMinutes': focusMinutes,
      'badges': badges,
    };
  }

  UserModel copyWith({
    String? name,
    String? photoUrl,
    int? streakDays,
    int? tasksCompleted,
    int? focusMinutes,
    List<String>? badges,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      joinedAt: joinedAt,
      streakDays: streakDays ?? this.streakDays,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      badges: badges ?? this.badges,
    );
  }
}
