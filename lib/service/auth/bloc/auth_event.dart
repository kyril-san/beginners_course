part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

final class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

final class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

final class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}

final class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

final class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogin(this.email, this.password);
}

final class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
