// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/auth/auth_exceptions.dart';
import 'package:beginners_course/service/auth/auth_provider.dart';
import 'package:beginners_course/service/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be Initiailized to begin wiht', () {
      expect(provider.isInitialized, false);
    });
    test('Cannot log out if not initialized', () {
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitialized>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider._isinitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialze in less thatn 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Creating a user to take me to Login page', () async {
      // await provider.initialize();
      final bademailUser = provider.createuser(
          email: 'dumbass@ass.com', password: 'anypassword');
      expect(
          bademailUser, throwsA(const TypeMatcher<UserNotLoggedInException>()));
      final badpassword =
          provider.createuser(email: 'someone@ass.com', password: '123456');
      expect(badpassword, throwsA(const TypeMatcher<WrongPassowrdException>()));

      final user = await provider.createuser(
          email: 'someone@ass.com', password: '12344444');
      expect(provider.currentUser, user);

      expect(user.isEmailVerified, false);
    });

    test('Logged In user should be able to get verifiec', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitialized implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isinitialized = false;
  bool get isInitialized => _isinitialized;
  AuthUser? _user;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 1));
    _isinitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitialized();
    if (email == 'Dumbass@ass.com') throw InvalidEmailAuthException();
    if (password == '123456') throw WrongPassowrdException();
    const user = AuthUser(isEmailVerified: false, email: '', id: 'my_id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitialized();
    if (_user == null) throw UserNotLoggedInException();
    await Future.delayed(Duration(seconds: 1));
    _user == null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitialized();
    if (_user == null) throw UserNotLoggedInException();
    const newUser = AuthUser(isEmailVerified: true, email: '', id: 'my_id');
    _user = newUser;
  }

  @override
  Future<AuthUser> createuser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitialized();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }
}
