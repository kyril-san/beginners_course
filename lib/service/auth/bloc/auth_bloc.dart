// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/auth/auth_provider.dart';
import 'package:beginners_course/service/auth/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthstateUninitialized()) {
    on<AuthEventShouldRegister>((event, emit) {
      emit(AuthStateRegistering(null));
    });

    //! initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(AuthStateLoggedOut(exception: null, isloading: false));
      } else if (!user.isEmailVerified) {
        emit(AuthStateNeedVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    //! Send Email Verifications
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    //! Register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createuser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(AuthStateNeedVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });
    //!log in
    on<AuthEventLogin>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        if (!user.isEmailVerified) {
          emit(AuthStateLoggedOut(exception: null, isloading: false));
          emit(AuthStateNeedVerification());
        } else {
          emit(AuthStateLoggedOut(exception: null, isloading: false));
        }
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isloading: false));
      }
    });
    //!log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(AuthStateLoggedOut(exception: null, isloading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isloading: false));
      }
    });
  }
}
