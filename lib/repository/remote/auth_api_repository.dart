import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/repository/interface/auth_repository.dart';

class AuthApiRepository implements AuthRepository {
  const AuthApiRepository();

  @override
  Future<User?> signInUsingEmailPassword({required String email, required String password}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided.');
      }
      throw FirebaseAuthException(code: e.code, message: e.message);
    }

    return user;
  }
}
