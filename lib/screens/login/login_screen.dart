// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:beginners_course/const/routes.dart';
import 'package:beginners_course/firebase_options.dart';
import 'package:beginners_course/utils/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
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
          title: Text('Login Page'),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(hintText: 'Put in your Email'),
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
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              homeroute,
                              (route) => false,
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email') {
                            if (mounted) {
                              await showErrorDialog(context, 'Invalid Email');
                            }
                          } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                            if (mounted) {
                              await showErrorDialog(context, e.code);
                            }
                          } else {
                            if (mounted) {
                              await showErrorDialog(
                                  context, 'Error: ${e.code.toUpperCase()}');
                            }
                          }

                          log(e.message.toString());
                        } catch (e) {
                          if (mounted) {
                            await showErrorDialog(
                                context, 'Error: ${e.toString()}');
                          }
                        }
                      },
                      child: Text('Login')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            registerroute, (route) => false);
                      },
                      child: Text('Not Registered yet? Click here!'))
                ],
              ),
            );
          },
        ));
  }
}
