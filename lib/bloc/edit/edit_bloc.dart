import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/bloc/edit/edit_event.dart';
import 'package:map_exam/bloc/edit/edit_state.dart';
import 'package:map_exam/model/note.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc() : super(const EditState()) {
    on<EditEventEditNote>(_editNote);
    on<EditEventAddNote>(_addNote);
  }

  _editNote(EditEventEditNote event, Emitter<EditState> emit) async {
    if (event.newTitle.isEmpty || event.newContent.isEmpty) return;
    debugPrint('editing.. (${event.email}, ${event.index})');

    try {
      await FirebaseFirestore.instance.collection('users').doc(event.email).update({
        'notes': (event.notes
              ..[event.index].title = event.newTitle
              ..[event.index].content = event.newContent)
            .map((v) => v.toJson())
            .toList(),
      }).then((_) {
        debugPrint('edited');
        emit(state.copyWith(isSucceed: true));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _addNote(EditEventAddNote event, Emitter<EditState> emit) async {
    if (event.newTitle.isEmpty || event.newContent.isEmpty) return;
    debugPrint('adding.. (${event.email}, ${event.newTitle})');

    try {
      await FirebaseFirestore.instance.collection('users').doc(event.email).set({
        'notes': FieldValue.arrayUnion([
          ...event.notes.map((e) => e.toJson()).toList(),
          Note(
            id: DateTime.now().microsecondsSinceEpoch.toString().substring(10),
            title: event.newTitle,
            content: event.newContent,
          ).toJson()
        ])
      }).then((_) {
        debugPrint('added');
        emit(state.copyWith(isSucceed: true));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
