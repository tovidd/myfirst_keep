import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/bloc/home/home_event.dart';
import 'package:map_exam/bloc/home/home_state.dart';
import 'package:map_exam/repository/response/api_response.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(const HomeState()) {
    on<HomeEventGetNotes>(_getNotes);
    on<HomeEventNoteCount>(_noteCount);
    on<HomeEventIsExpand>(_isExpand);
    on<HomeEventShowEditingTools>(_showEditingTools);
    on<HomeEventDeleteNote>(_deleteNote);
  }

  _getNotes(HomeEventGetNotes event, Emitter<HomeState> emit) async {
    if (!event.skipLoading) {
      emit(state.copyWith(notes: ApiResponse.loading()));
    }

    try {
      final DocumentSnapshot result = await FirebaseFirestore.instance.collection('users').doc(event.email).get();
      debugPrint(result.toString());
      emit(state.copyWith(notes: ApiResponse.completed(result)));
    } catch (e) {
      emit(state.copyWith(notes: ApiResponse.error()));
    }
  }

  _noteCount(HomeEventNoteCount event, Emitter<HomeState> emit) async {
    emit(state.copyWith(noteCount: event.noteCount));
  }

  _isExpand(HomeEventIsExpand event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isExpand: event.isExpand));
  }

  _showEditingTools(HomeEventShowEditingTools event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
        showEditingToolsIndex:
            event.showEditingToolsIndex == state.showEditingToolsIndex ? null : event.showEditingToolsIndex));
  }

  _deleteNote(HomeEventDeleteNote event, Emitter<HomeState> emit) async {
    debugPrint('deleting.. (${event.email}, ${event.note.id})');
    try {
      await FirebaseFirestore.instance.collection('users').doc(event.email).update({
        'notes': FieldValue.arrayRemove([event.note.toJson()])
      }).then((value) {
        add(HomeEventGetNotes(event.email, skipLoading: true));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
