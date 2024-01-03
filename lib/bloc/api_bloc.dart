import 'package:flutter_bloc/flutter_bloc.dart';
import '../Note.dart';
import 'api_events.dart';
import 'api_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiBloc extends Bloc<ApiEvents, ApiStates> {
  ApiBloc() : super(NoteListState([])) {
    on<NoteListEvent>(_getNoteList);
    on<SaveNoteEvent>(_saveNote);
    on<UpdateNoteEvent>(_updateNote);
    on<CreateEditScreenEvent>(_createEditScreen);
    on<NoteDetailsEvent>(_noteDetails);
  }

  // Fetches the list of notes from Firestore
  _getNoteList(NoteListEvent event, Emitter<ApiStates> emitter) async {
    emit(LoadingState()); // Emit loading state
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('note').get();
      // Fetch data from Firestore
      List<Note> notes = await querySnapshot.docs.map((doc) {
        var reminderDate = doc['reminderDate'];
        if (reminderDate == null) {
          // Если дата напоминания отсутствует, установите ее в значение null или другое значение по умолчанию
          reminderDate = null; // Или установите другое значение по умолчанию
        }
        return Note(
          id: doc.id,
          title: doc['title'],
          content: doc['content'],
          creationTime: doc['creationTime'],
          reminderDate: reminderDate,
        );
      }).toList();
      emitter(
          NoteListState(notes)); // Emit note list state with the fetched notes
    } catch (error) {
      print(error);
      print("error1");
      emitter(ErrorState()); // Emit error state in case of an error
    }
  }

  // Saves a new note to Firestore
  _saveNote(SaveNoteEvent event, Emitter<ApiStates> emit) async {
    emit(LoadingState()); // Emit loading state
    try {
      Timestamp? reminderDate = event.note.reminderDate;
      if (reminderDate == null) {
        // Если дата напоминания отсутствует, установите ее в значение null или другое значение по умолчанию
        reminderDate = null; // Или установите другое значение по умолчанию
      }

      await FirebaseFirestore.instance.collection('note').add({
        'title': event.note.title,
        'content': event.note.content,
        'creationTime': Timestamp.now(),
        'reminderDate': reminderDate,
      });

      emit(NoteDetailsState(
          event.note)); // Emit note details state for the saved note
    } catch (error) {
      print(error);
      print("error2");
      emit(ErrorState()); // Emit error state in case of an error
    }
  }

  // Updates an existing note in Firestore
  _updateNote(UpdateNoteEvent event, Emitter<ApiStates> emit) async {
    emit(LoadingState()); // Emit loading state
    try {
      Timestamp? reminderDate = event.note.reminderDate;
      if (reminderDate == null) {
        // Если дата напоминания отсутствует, установите ее в значение null или другое значение по умолчанию
        reminderDate = null; // Или установите другое значение по умолчанию
      }
      await FirebaseFirestore.instance
          .collection('note')
          .doc(event.note.id)
          .update({
        'title': event.note.title,
        'content': event.note.content,
        'creationTime': Timestamp.now(),
        'reminderDate': reminderDate,
      });

      emit(NoteDetailsState(
          event.note)); // Emit note details state for the updated note
    } catch (error) {
      print(error);
      emit(ErrorState()); // Emit error state in case of an error
    }
  }

  // Navigates to the create/edit note screen with the provided note
  _createEditScreen(CreateEditScreenEvent event, Emitter<ApiStates> emit) {
    emit(CreateEditScreenState(event.note));
  }

  // Navigates to the note details screen for the provided note
  _noteDetails(NoteDetailsEvent event, Emitter<ApiStates> emit) {
    emit(NoteDetailsState(event.note));
  }
}
