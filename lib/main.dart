import 'package:flutter/material.dart';
import 'package:map_exam/di/injection_container.dart' as di;

import 'screen/home_screen.dart';
// import 'login_screen.dart';
// import 'edit_screen.dart';

void main() async {
  await di.initInjection();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myFirst',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const LoginScreen(),
      home: const HomeScreen(),
      // home: const EditScreen(),
    );
  }
}
