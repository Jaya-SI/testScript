import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LupaPass extends StatefulWidget {
  const LupaPass({Key? key}) : super(key: key);

  @override
  State<LupaPass> createState() => _LupaPassState();
}

class _LupaPassState extends State<LupaPass> {
  TextEditingController emailController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    headerLupa() {
      return Container(
        child: Center(
          child: Text(
            'Masukkan Email yang sudah terdaftar',
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

    btnKirim() {
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
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: emailController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Berhasil Dikirim Silahkan cek email / spam email'),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
                context, '/signIN', (route) => false);
          },
          child: Text(
            'Kirim Sekarang',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Reset Password',
          ),
        ),
        body: SafeArea(
            child: ListView(
          children: [
            SizedBox(height: 30),
            headerLupa(),
            SizedBox(height: 10),
            formEmail(),
            SizedBox(height: 30),
            btnKirim(),
          ],
        )));
  }
}
