import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/bloc/login/login_event.dart';
import 'package:map_exam/bloc/login/login_state.dart';
import 'package:map_exam/di/injection_container.dart';
import 'package:map_exam/repository/interface/auth_repository.dart';
import 'package:map_exam/repository/response/api_response.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _repo = inject<AuthRepository>();

  LoginBloc() : super(const LoginState()) {
    on<LoginEventSignIn>(_signIn);
  }

  _signIn(LoginEventSignIn event, Emitter<LoginState> emit) async {
    emit(state.copyWith(data: ApiResponse.loading()));
    try {
      debugPrint('sign in: (${event.email}, ${event.password})');
      final res = await _repo.signInUsingEmailPassword(email: event.email, password: event.password);
      debugPrint(res.toString());
      emit(state.copyWith(data: ApiResponse.completed(res)));
    } catch (e) {
      debugPrint('Sign in failed');
      emit(state.copyWith(data: ApiResponse.error()));
    }
  }
}
