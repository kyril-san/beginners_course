// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/screens/home/home_page.dart';
import 'package:beginners_course/screens/login/login_screen.dart';
import 'package:beginners_course/service/auth/auth_service.dart';
import 'package:beginners_course/verify_page.dart';
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
        future: Authservice.firebase().initialize(),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = Authservice.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return HomePage();
                } else {
                  return VerifyEmailPage();
                }
              } else {
                return LoginPage();
              }

            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }
}
