import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final Timestamp creationTime;
  final Timestamp? reminderDate;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.creationTime,
    this.reminderDate,
  });
}
