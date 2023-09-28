// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/auth/auth_provider.dart';
import 'package:beginners_course/service/auth/auth_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthstateLoading()) {
    //! initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(AuthStateNeedVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });
    //!log in
    on<AuthEventLogin>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });
    //!log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        emit(AuthstateLoading());
        await provider.logOut();
        emit(AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}
