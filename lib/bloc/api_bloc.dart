import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../Note.dart';
import 'api_events.dart';
import 'api_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiBloc extends Bloc<ApiEvents, ApiStates> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  ApiBloc() : super(NoteListState([])) {
    on<NoteListEvent>(_getNoteList);
    on<SaveNoteEvent>(_saveNote);
    on<UpdateNoteEvent>(_updateNote);
  }

  _getNoteList(NoteListEvent event, Emitter<ApiStates> emitter) async {
    try {
      // Получение данных из Firestore
      List<Note> notes = await getNotes();

      // Отправка списка профилей в состояние ListProfilesState
      emitter(NoteListState(notes));
    } catch (error) {
      print(error);
      emitter(ErrorState());
    }
  }

  Future<List<Note>> getNotes() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('note').get();
    List<Note> notes = querySnapshot.docs
        .map((doc) => Note(
              id: doc.id,
              title: doc['title'],
              content: doc['content'],
              creationTime: doc['creationTime'],

            ))
        .toList();
    return notes;
  }

  _saveNote(SaveNoteEvent event, Emitter<ApiStates> emit) async {
    try {
      // Сохранение записи в Firestore
      await FirebaseFirestore.instance.collection('note').add({
        'title': event.note.title,
        'content': event.note.content,
        'creationTime': DateTime.now(),
        // Другие поля записи, если необходимо
      });
      List<Note> notes = await getNotes();
      emit(NoteListState([]..addAll(notes)));
    } catch (error) {
      print(error);
      emit(ErrorState());
    }
  }

  _updateNote(UpdateNoteEvent event, Emitter<ApiStates> emit) async {
    try {
      // Обновление записи в Firestore
      await FirebaseFirestore.instance
          .collection('note')
          .doc(event.note.id)
          .update({
        'title': event.note.title,
        'content': event.note.content,
        'creationTime': DateTime.now(),
        // Другие поля записи, если необходимо
      });
      emit(NoteListState([]));
    } catch (error) {
      print(error);
      emit(ErrorState());
    }
  }
}
