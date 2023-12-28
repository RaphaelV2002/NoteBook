import 'package:google_sign_in/google_sign_in.dart';
import '../Note.dart';

abstract class ApiStates {}

class InitState extends ApiStates {}

class LoadingState extends ApiStates {}

class ErrorState extends ApiStates {
  // String error;
  //
  // ErrorState(this.error);
}



class NoteListState extends ApiStates {
  final List<Note> notes;

  NoteListState(this.notes);
}
class SaveNoteState extends ApiStates {
}
