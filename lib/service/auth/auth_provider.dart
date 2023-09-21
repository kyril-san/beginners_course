import 'package:beginners_course/service/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser?> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createuser({
    required String email,
    required String password,
  });

  Future<void> sendEmailVerification();
  Future<void> logOut();
}
