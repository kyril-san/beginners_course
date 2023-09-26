// ignore_for_file: unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:beginners_course/const/routes.dart';
import 'package:beginners_course/screens/home/home_page.dart';
import 'package:beginners_course/screens/notes/new_notes_view.dart';
import 'package:beginners_course/screens/verify/check_verify_page.dart';
import 'package:beginners_course/screens/login/login_screen.dart';
import 'package:beginners_course/screens/register/register_screen.dart';
import 'package:beginners_course/verify_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CheckVerificationPage(),
      routes: {
        loginroute: (context) => LoginPage(),
        registerroute: (context) => Registerview(),
        homeroute: (context) => HomePage(),
        verifyemail: (context) => VerifyEmailPage(),
        newnotesview: (context) => NewNotesViewsPage()
      },
    );
  }
}
