import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/argument/login_argument.dart';
import 'package:map_exam/bloc/login/login_bloc.dart';
import 'package:map_exam/bloc/login/login_event.dart';
import 'package:map_exam/bloc/login/login_state.dart';
import 'package:map_exam/di/injection_container.dart';
import 'package:map_exam/repository/response/api_response.dart';
import 'package:map_exam/screen/screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';
  // static Route route() => MaterialPageRoute(builder: (_) => const LoginScreen());
  const LoginScreen() : super(key: const Key('login'));

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'user1@gmail.com');
  final _passwordController = TextEditingController(text: 'pwd123');
  final LoginBloc bloc = inject<LoginBloc>();

  @override
  void initState() {
    _initializeFirebase();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp().then((value) {
      return value;
    });
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in', style: TextStyle(fontSize: 35.0)),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(hintText: 'Type your email here'),
                onTap: () {},
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Type your password',
                ),
                onTap: () {},
              ),
              const SizedBox(height: 10.0),
              BlocListener<LoginBloc, LoginState>(
                bloc: bloc,
                listenWhen: (previous, current) => previous.data != current.data,
                listener: (context, state) {
                  if (state.data.status == Status.completed) {
                    Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false,
                        arguments: LoginArgument(email: state.data.data?.email));
                  }
                },
                child: ElevatedButton(
                  child: const Text('Sign in'),
                  onPressed: () {
                    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) return;
                    bloc.add(LoginEventSignIn(_usernameController.text, _passwordController.text));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
