import 'package:equatable/equatable.dart';

class EditState extends Equatable {
  final bool isSucceed;
  const EditState({this.isSucceed = false});

  EditState copyWith({bool? isSucceed}) {
    return EditState(
      isSucceed: isSucceed ?? this.isSucceed,
    );
  }

  @override
  List<Object?> get props => [isSucceed];
}
