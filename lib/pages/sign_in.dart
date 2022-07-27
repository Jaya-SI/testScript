import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIN extends StatefulWidget {
  const SignIN({Key? key}) : super(key: key);

  @override
  State<SignIN> createState() => _SignINState();
}

class _SignINState extends State<SignIN> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    headerSIGNIN() {
      return Container(
        child: Center(
          child: Text(
            'Silahkan login dengan akun yang telah terdaftar',
          ),
        ),
      );
    }

    formEmail() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: emailController,
          decoration: InputDecoration(
              labelText: 'Email',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              )),
        ),
      );
    }

    formPassword() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: passController,
          decoration: InputDecoration(
              labelText: 'Password',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.blue),
                borderRadius: BorderRadius.circular(15),
              )),
        ),
      );
    }

    btnSignIN() {
      return Container(
        height: 55,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
          onPressed: () async {
            try {
              UserCredential userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passController.text);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/signUP', (route) => false);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User belum terdaftar'),
                  ),
                );
              } else if (e.code == 'wrong-password') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password Salah'),
                  ),
                );
              }
            }
          },
          child: Text(
            'Login Sekarang',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    btnSignUP() {
      return Container(
        height: 55,
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/daftar');
          },
          child: Text(
            'daftar Sekarang',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(height: 30),
          headerSIGNIN(),
          SizedBox(height: 20),
          formEmail(),
          SizedBox(height: 20),
          formPassword(),
          SizedBox(height: 30),
          btnSignIN(),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/lupa');
            },
            child: Text(
              'Lupa Password',
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Belum Punya akun ?'),
              btnSignUP(),
            ],
          ),
        ],
      )),
    );
  }
}
