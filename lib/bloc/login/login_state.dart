import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_exam/repository/response/api_response.dart';

class LoginState extends Equatable {
  final ApiResponse<User> data;
  const LoginState({
    this.data = const ApiResponse.initial(),
  });

  LoginState copyWith({ApiResponse<User>? data}) {
    return LoginState(
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [
        data,
      ];
}
