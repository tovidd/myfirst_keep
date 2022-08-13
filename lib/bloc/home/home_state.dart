import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_exam/repository/response/api_response.dart';

class HomeState extends Equatable {
  final ApiResponse<dynamic> notes;
  final int? noteCount;
  final bool? isExpand;
  const HomeState({
    this.notes = const ApiResponse.initial(),
    this.noteCount = 0,
    this.isExpand = true,
  });

  HomeState copyWith({ApiResponse<dynamic>? notes, int? noteCount, bool? isExpand}) {
    return HomeState(
      notes: notes ?? this.notes,
      noteCount: noteCount ?? this.noteCount,
      isExpand: isExpand ?? this.isExpand,
    );
  }

  @override
  List<Object?> get props => [
        notes,
        noteCount,
        isExpand,
      ];
}
