// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/helpers/loading/loading_screen.dart';
import 'package:beginners_course/screens/ForgotPassword/forgot_password_screen.dart';
import 'package:beginners_course/screens/home/home_page.dart';
import 'package:beginners_course/screens/login/login_screen.dart';
import 'package:beginners_course/screens/register/register_screen.dart';
import 'package:beginners_course/service/auth/bloc/auth_bloc.dart';
import 'package:beginners_course/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckVerificationPage extends StatelessWidget {
  const CheckVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingtext ?? 'Please wait a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return HomePage();
        } else if (state is AuthStateNeedVerification) {
          return VerifyEmailPage();
        } else if (state is AuthStateRegistering) {
          return Registerview();
        } else if (state is AuthstateForgotPassword) {
          return ForgotPasswordView();
        } else if (state is AuthStateLoggedOut) {
          return LoginPage();
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
