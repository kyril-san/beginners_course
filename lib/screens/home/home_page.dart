// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/firebase_options.dart';
import 'package:beginners_course/screens/login/login_screen.dart';
import 'package:beginners_course/verify_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              print(user);
              if (user!.emailVerified) {
                return LoginPage();
              } else {
                return VerifyEmailPage();
              }

            default:
              return CircularProgressIndicator();
          }
        });
  }
}
