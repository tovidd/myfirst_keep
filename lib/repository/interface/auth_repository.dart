import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  });
}
