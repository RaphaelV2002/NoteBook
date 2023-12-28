import 'package:flutter/material.dart';
import '../../Note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';
import '../bloc/api_states.dart';
import 'bloc/api_events.dart';
import 'NoteDetailsScreen.dart';
import 'CreateEditNoteScreen.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';

class NoteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ApiBloc>(context).add(NoteListEvent());
    return Scaffold(
      appBar: AppBar(
        title: Text('Note List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Обработка нажатия на кнопку
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditNoteScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<ApiBloc, ApiStates>(
        builder: (context, state) {
          print(state);
          if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NoteListState) {
            return buildNoteGrid(state.notes);
          } else {
            return Center(child: Text('Failed to load notes'));
          }
        },
      ),
    );
  }

  Widget buildNoteGrid(List<Note> notes) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Количество столбцов в сетке
        crossAxisSpacing: 8.0, // Пространство между столбцами
        mainAxisSpacing: 8.0, // Пространство между строками
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          child: InkWell(
            onTap: () {
              // Переход к экрану деталей заметки при нажатии
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailsScreen(note: note),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(note.content),
                  SizedBox(height: 8),
                  Text(
                    'Created on: ${note.creationTime.toDate().toString()}', // Вывод времени создания
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
