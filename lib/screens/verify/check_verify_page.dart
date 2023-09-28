// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/screens/home/home_page.dart';
import 'package:beginners_course/screens/login/login_screen.dart';
import 'package:beginners_course/service/auth/bloc/auth_bloc.dart';
import 'package:beginners_course/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckVerificationPage extends StatelessWidget {
  const CheckVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
        // bloc: AuthBloc,
        builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return HomePage();
      }
      if (state is AuthStateNeedVerification) {
        return VerifyEmailPage();
      }
      if (state is AuthStateLoggedOut) {
        return LoginPage();
      }
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    });
  }
}
