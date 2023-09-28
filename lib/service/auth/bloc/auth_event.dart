part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

final class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

final class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogin(this.email, this.password);
}

final class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
