import 'package:beginners_course/service/auth/auth_provider.dart';
import 'package:beginners_course/service/auth/auth_user.dart';
import 'package:beginners_course/service/auth/firebase_auth_provider.dart';

class Authservice implements AuthProvider {
  final AuthProvider provider;

  const Authservice(this.provider);

  factory Authservice.firebase() => Authservice(FirebaseAuthProvider());

  @override
  Future<AuthUser> createuser({
    required String email,
    required String password,
  }) =>
      provider.createuser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
