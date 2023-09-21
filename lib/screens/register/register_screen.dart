// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:beginners_course/firebase_options.dart';
import 'package:beginners_course/screens/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registerview extends StatefulWidget {
  const Registerview({super.key});

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _email,
                        decoration:
                            InputDecoration(hintText: 'Put in your Email'),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _password,
                        decoration:
                            InputDecoration(hintText: 'Put in your Password'),
                        obscureText: true,
                        obscuringCharacter: '*',
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                      SizedBox(height: 10),
                      TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              log(userCredential.toString());
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                log('Weak Password');
                              } else if (e.code == 'email-already-in-use') {
                                log('Email Already in use');
                              }
                            } catch (e) {
                              log(e.runtimeType.toString());
                            }
                          },
                          child: Text('Register')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => LoginPage()),
                                (route) => false);
                          },
                          child: Text('Click here to Login'))
                    ],
                  ),
                );

              default:
                return CircularProgressIndicator();
            }
          }),
    );
  }
}
