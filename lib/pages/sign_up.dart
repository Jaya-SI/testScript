import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_script/pages/home_page.dart';
import 'package:test_script/pages/verify_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController namaController = TextEditingController(text: '');
  TextEditingController passController = TextEditingController(text: '');
  TextEditingController passControllerConformation =
      TextEditingController(text: '');
  String passSend = '';

  Future addUser(String nama, String email) async {
    await FirebaseFirestore.instance.collection('UserData').add(
      {
        'nama': nama,
        'email': email,
      },
    );
  }

  Future signUP() async {
    if (passController.text != passControllerConformation.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sesuaikan Password Anda !'),
        ),
      );
    } else {
      setState(() {
        passSend = passController.text;
      });
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passSend,
        )
            // addUser(namaController.text.trim(), emailController.text.trim());
            .then((value) {
          FirebaseFirestore.instance
              .collection('UserData')
              .doc(value.user!.uid)
              .set({
            'nama': namaController.text,
            'email': value.user!.email,
          });
        });

        Navigator.pushNamed(context, '/signUP');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password terlalu pendek'),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email sudah terdaftar'),
            ),
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    headerSignUp() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: Text(
            'Selamat Data Silahkan Register',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      );
    }

    fromNama() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: namaController,
          decoration: InputDecoration(
              labelText: 'Nama',
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

    fromConPass() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: passControllerConformation,
          decoration: InputDecoration(
              labelText: 'Input Ulang Password',
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

    btnSignUp() {
      return Container(
        height: 55,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
          onPressed: () {
            signUP();
          },
          child: Text(
            'Register Sekarang',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    btnSignIn() {
      return Container(
        height: 55,
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signIN');
          },
          child: Text(
            'Login Sekarang',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'SignUp',
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            headerSignUp(),
            SizedBox(height: 20),
            fromNama(),
            SizedBox(height: 10),
            formEmail(),
            SizedBox(height: 10),
            formPassword(),
            SizedBox(height: 10),
            fromConPass(),
            SizedBox(height: 30),
            btnSignUp(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah Punya akun ?'),
                btnSignIn(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
