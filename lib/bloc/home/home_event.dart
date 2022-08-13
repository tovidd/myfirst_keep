import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeEventGetNotes extends HomeEvent {
  final String email;
  HomeEventGetNotes(this.email);

  @override
  List<Object?> get props => [email];
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
