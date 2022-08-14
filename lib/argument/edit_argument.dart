import 'package:map_exam/constant/note_action.dart';
import 'package:map_exam/model/note.dart';

class EditArgument {
  NoteAction? action;
  List<Note>? notes;
  int? index;
  EditArgument({this.action = NoteAction.view, this.notes, this.index});
}
