import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_script/pages/lupaPass_page.dart';
import 'package:test_script/pages/main_page.dart';
import 'package:test_script/pages/sign_in.dart';
import 'package:test_script/pages/sign_up.dart';
import 'package:test_script/pages/verify_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/signUP': (context) => VerifyPage(),
        '/daftar':(context) => SignUp(),
        '/signIN':(context) => SignIN(),
        '/lupa':(context) => LupaPass(),
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return VerifyPage();
            } else {
              return SignUp();
            }
          },
        ),
      ),
    );
  }
}
