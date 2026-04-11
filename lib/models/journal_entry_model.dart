import 'package:cloud_firestore/cloud_firestore.dart';

enum MoodType { great, good, okay, tired, stressed }

class JournalEntryModel {
  final String id;
  final String userId;
  final String content;
  final MoodType mood;
  final DateTime date;

  JournalEntryModel({
    required this.id,
    required this.userId,
    required this.content,
    this.mood = MoodType.okay,
    required this.date,
  });

  factory JournalEntryModel.fromMap(Map<String, dynamic> map) {
    return JournalEntryModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      mood: MoodType.values.firstWhere(
        (e) => e.name == map['mood'],
        orElse: () => MoodType.okay,
      ),
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'mood': mood.name,
      'date': Timestamp.fromDate(date),
    };
  }
}
