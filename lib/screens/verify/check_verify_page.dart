// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/firebase_options.dart';
import 'package:beginners_course/screens/home/home_page.dart';
import 'package:beginners_course/screens/login/login_screen.dart';
import 'package:beginners_course/verify_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CheckVerificationPage extends StatefulWidget {
  const CheckVerificationPage({super.key});

  @override
  State<CheckVerificationPage> createState() => _CheckVerificationPageState();
}

class _CheckVerificationPageState extends State<CheckVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return HomePage();
                } else {
                  return VerifyEmailPage();
                }
              } else {
                return LoginPage();
              }

            default:
              return CircularProgressIndicator();
          }
        });
  }
}
