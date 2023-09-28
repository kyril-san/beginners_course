// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:beginners_course/service/auth/bloc/auth_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            Text(
                "We've have sent you an email verifications. Please Click the link to verify"),
            Text(
                'If you have not received an email, Please click this link below to verify your email.'),
            TextButton(
                onPressed: () async {
                  context
                      .read<AuthBloc>()
                      .add(AuthEventSendEmailVerification());
                },
                child: Text('Send email verification')),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(AuthEventLogOut());
                },
                child: Text('Restart'))
          ],
        ),
      ),
    );
  }
}
