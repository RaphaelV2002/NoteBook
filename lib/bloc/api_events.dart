import 'package:google_sign_in/google_sign_in.dart';
import 'package:unihelp/bloc/api_states.dart';
import '../Note.dart';

abstract class ApiEvents {}

class NoteListEvent extends ApiEvents {}

class SaveNoteEvent extends ApiEvents {
  final Note note;

  SaveNoteEvent(this.note);


}

class UpdateNoteEvent extends ApiEvents {
  final Note note;

  UpdateNoteEvent(this.note);


}