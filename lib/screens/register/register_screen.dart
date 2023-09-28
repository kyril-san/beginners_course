// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/auth/auth_exceptions.dart';
import 'package:beginners_course/service/auth/auth_service.dart';
import 'package:beginners_course/service/auth/bloc/auth_bloc.dart';
import 'package:beginners_course/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyinUseException) {
            await showErrorDialog(context, 'Email Already in Use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid Email Used');
          } else if (state.exception is GenericAuthExceptions) {
            await showErrorDialog(
                context, 'Registration Error \nPlease Try again Later');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
            future: Authservice.firebase().initialize(),
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
                              context
                                  .read<AuthBloc>()
                                  .add(AuthEventRegister(email, password));
                            },
                            child: Text('Register')),
                        TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthEventLogOut());
                            },
                            child: Text('Click here to Login'))
                      ],
                    ),
                  );

                default:
                  return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
