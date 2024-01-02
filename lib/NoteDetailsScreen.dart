import 'package:flutter/material.dart';
import 'package:unihelp/bloc/api_events.dart';
import '../../Note.dart';
import 'CreateEditNoteScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';
Widget NoteDetailsScreen(BuildContext context, Note note) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Note Details'),
      leading:  BackButton(
        onPressed: () {
          BlocProvider.of<ApiBloc>(context).add(NoteListEvent());
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        BlocProvider.of<ApiBloc>(context)
            .add(CreateEditScreenEvent(note: note));
      },
      child: Icon(Icons.edit),
    ),
    body: Padding(
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
    ),
  );
}
