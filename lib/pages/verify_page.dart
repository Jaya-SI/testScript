import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_script/pages/home_page.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool isVerifed = false;
  Timer? timer;
  bool resendEmail = false;

  @override
  void initState() {
    super.initState();
    isVerifed = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isVerifed) {
      sendVerifEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkVerifikasi(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkVerifikasi() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerifed = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerifed) {
      timer?.cancel();
    }
  }

  Future sendVerifEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        resendEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        resendEmail = true;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return isVerifed
        ? HomePage()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Verifikasi Email'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verifikasi email sudah dikirim silahkan lihat di spam',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: 300,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      resendEmail ? sendVerifEmail : null;
                    },
                    child: Text(
                      'Kirim Ulang',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/signIN', (route) => false);
                  },
                  child: Text(
                    'Cancel',
                  ),
                ),
              ],
            ),
          );
  }
}
