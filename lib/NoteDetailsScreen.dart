import 'package:flutter/material.dart';
import '../../Note.dart';
import 'CreateEditNoteScreen.dart';

class NoteDetailsScreen extends StatelessWidget {
  final Note note;

  NoteDetailsScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Обработка нажатия на кнопку
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditNoteScreen(note: note),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: buildPadding(),
    );
  }

  Padding buildPadding() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            note.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            note.content,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
