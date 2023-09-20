// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:beginners_course/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify your email'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Please click this link below to verify your email.'),
            TextButton(
                onPressed: () async {
                  await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform);
                  final user = FirebaseAuth.instance.currentUser;
                  await user!.sendEmailVerification();
                },
                child: Text('Send email verification'))
          ],
        ),
      ),
    );
  }
}
