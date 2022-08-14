import 'package:equatable/equatable.dart';
import 'package:map_exam/model/note.dart';

abstract class EditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditEventEditNote extends EditEvent {
  final String email;
  final List<Note> notes;
  final int index;
  final String newTitle;
  final String newContent;
  EditEventEditNote({
    required this.email,
    required this.notes,
    required this.index,
    required this.newTitle,
    required this.newContent,
  });

  @override
  List<Object?> get props => [email, notes, index, newTitle, newContent];
}

class EditEventAddNote extends EditEvent {
  final String email;
  final List<Note> notes;
  final String newTitle;
  final String newContent;
  EditEventAddNote({
    required this.email,
    required this.notes,
    required this.newTitle,
    required this.newContent,
  });

  @override
  List<Object?> get props => [email, notes, newTitle, newContent];
}
