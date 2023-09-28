// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/auth/auth_exceptions.dart';
import 'package:beginners_course/service/auth/auth_service.dart';
import 'package:beginners_course/service/auth/bloc/auth_bloc.dart';
import 'package:beginners_course/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is InvalidLoginCredentialsException) {
            await showErrorDialog(context, 'Invalid Login Credentials');
          } else if (state.exception is InvalidEmailException) {
            await showErrorDialog(context, 'Invalid Email Address Used');
          } else if (state.exception is WrongPassowrdException) {
            await showErrorDialog(context, 'Wrong Password');
          } else if (state.exception is GenericAuthExceptions) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Login Page'),
            backgroundColor: Colors.blue,
          ),
          body: FutureBuilder(
            future: Authservice.firebase().initialize(),
            builder: (context, snapshot) {
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
                          context
                              .read<AuthBloc>()
                              .add(AuthEventLogin(email, password));
                        },
                        child: Text('Login')),
                    SizedBox(height: 10),
                    TextButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(AuthEventForgotPassword());
                        },
                        child: Text('I forgot my Passowrd')),
                    TextButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(AuthEventForgotPassword());
                        },
                        child: Text('Not Registered yet? Click here!'))
                  ],
                ),
              );
            },
          )),
    );
  }
}
