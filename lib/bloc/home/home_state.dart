import 'package:equatable/equatable.dart';
import 'package:map_exam/repository/response/api_response.dart';

class HomeState extends Equatable {
  final ApiResponse<dynamic> notes;
  final int? noteCount;
  final bool? isExpand;
  final int? showEditingToolsIndex;
  const HomeState({
    this.notes = const ApiResponse.initial(),
    this.noteCount = 0,
    this.isExpand = true,
    this.showEditingToolsIndex = -1,
  });

  HomeState copyWith({
    ApiResponse<dynamic>? notes,
    int? noteCount,
    bool? isExpand,
    List<bool>? showEditingTools,
    int? showEditingToolsIndex,
  }) {
    return HomeState(
      notes: notes ?? this.notes,
      noteCount: noteCount ?? this.noteCount,
      isExpand: isExpand ?? this.isExpand,
      showEditingToolsIndex: showEditingToolsIndex ?? -1,
    );
  }

  @override
  List<Object?> get props => [
        notes,
        noteCount,
        isExpand,
        showEditingToolsIndex,
      ];
}
