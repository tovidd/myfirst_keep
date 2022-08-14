import 'package:get_it/get_it.dart';
import 'package:map_exam/bloc/edit/edit_bloc.dart';
import 'package:map_exam/bloc/home/home_bloc.dart';
import 'package:map_exam/bloc/login/login_bloc.dart';
import 'package:map_exam/repository/interface/auth_repository.dart';
import 'package:map_exam/repository/remote/auth_api_repository.dart';

final inject = GetIt.instance;

Future<void> initInjection() async {
  inject.registerFactory(() => LoginBloc());
  inject.registerFactory(() => HomeBloc());
  inject.registerFactory(() => EditBloc());
  inject.registerLazySingleton<AuthRepository>(() => const AuthApiRepository());
}
