import 'package:equatable/equatable.dart';
import 'package:map_exam/model/note.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeEventGetNotes extends HomeEvent {
  final String email;
  final bool skipLoading;
  HomeEventGetNotes(this.email, {this.skipLoading = false});

  @override
  List<Object?> get props => [email, skipLoading];
}

class HomeEventNoteCount extends HomeEvent {
  final int noteCount;
  HomeEventNoteCount(this.noteCount);

  @override
  List<Object?> get props => [noteCount];
}

class HomeEventIsExpand extends HomeEvent {
  final bool isExpand;
  HomeEventIsExpand(this.isExpand);

  @override
  List<Object?> get props => [isExpand];
}

class HomeEventShowEditingTools extends HomeEvent {
  final int? showEditingToolsIndex;
  HomeEventShowEditingTools(this.showEditingToolsIndex);

  @override
  List<Object?> get props => [showEditingToolsIndex];
}

class HomeEventDeleteNote extends HomeEvent {
  final String email;
  final Note note;
  HomeEventDeleteNote(this.email, this.note);

  @override
  List<Object?> get props => [email, note];
}
