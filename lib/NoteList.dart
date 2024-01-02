import 'package:flutter/material.dart';
import '../../Note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';
import '../bloc/api_states.dart';
import 'bloc/api_events.dart';
import 'NoteDetailsScreen.dart';
import 'CreateEditNoteScreen.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Widget NoteListScreen(context,List<Note> notes) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Note List'),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        BlocProvider.of<ApiBloc>(context).add(CreateEditScreenEvent());
      },
      child: Icon(Icons.add),
    ),
    body: GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Количество столбцов в сетке
        crossAxisSpacing: 1.0, // Пространство между столбцами
        mainAxisSpacing: 1.0, // Пространство между строками
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          child: InkWell(
            onTap: () {
              BlocProvider.of<ApiBloc>(context).add(NoteDetailsEvent(note));
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Обрезать текст и добавить многоточие, если он слишком длинный
                    maxLines: 1, // Ограничить количество строк
                  ),
                  SizedBox(height: 8),
                  Text(
                    note.content,
                    overflow: TextOverflow.ellipsis, // Обрезать текст и добавить многоточие, если он слишком длинный
                    maxLines: 3, // Ограничить количество строк
                  ),
                  Expanded(child: Container()),
                  // Добавляем Expanded, чтобы разместить дату и время внизу
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('dd MMMM yyyy HH:mm')
                          .format(note.creationTime.toDate()),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
