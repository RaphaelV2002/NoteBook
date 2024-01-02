import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final Timestamp creationTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.creationTime,
  });
}
