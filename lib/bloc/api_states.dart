import '../Note.dart';

abstract class ApiStates {}

class InitState extends ApiStates {}

class LoadingState extends ApiStates {}

class ErrorState extends ApiStates {}

class NoteListState extends ApiStates {
  final List<Note> notes;

  NoteListState(this.notes);
}

class SaveNoteState extends ApiStates {}

class CreateEditScreenState extends ApiStates {
  final Note? note;

  CreateEditScreenState(this.note);
}

class NoteDetailsState extends ApiStates {
  final Note note;

  NoteDetailsState(this.note);
}
