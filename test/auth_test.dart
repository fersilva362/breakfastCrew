import 'package:test/test.dart';
import 'package:user_app/services/auth/auth_exceptions.dart';
import 'package:user_app/services/auth/auth_provider.dart';
import 'package:user_app/services/auth/auth_user.dart';
//import 'dart:developer' as devtools show log;

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test('cannot logout if not initialzed', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('Should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should be null after initialized', () {
      expect(provider.currentUser, null);
    });
    test('Should be able to initialize in less 2 sec', () async {
      await provider.initialize();

      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('Create user should delegate to logIn function', () async {
      final badEmailUser =
          provider.createUser(email: 'foo@bar.com', password: 'password');
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthExceptions>()));
      final badPassword =
          provider.createUser(email: 'email', password: 'foobar');
      expect(badPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthExceptions>()));

      final user =
          await provider.createUser(email: 'email', password: 'password');

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Login should be able to get verified', () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to logout and login', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      expect(provider.currentUser, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  AuthUser? _user;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw (NotInitializedException());
    }
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw (NotInitializedException());
    }
    if (email == 'foo@bar.com') {
      throw UserNotFoundAuthExceptions();
    }
    if (password == 'foobar') {
      throw WrongPasswordAuthExceptions();
    }
    const user = AuthUser(isEmailVerified: false, email: 'foo', id: 'my-id');
    _user = user;
    return await Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) {
      throw (NotInitializedException());
    }
    if (_user == null) {
      throw UserNotFoundAuthExceptions();
    }
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) {
      throw (NotInitializedException());
    }

    if (_user == null) {
      throw UserNotFoundAuthExceptions();
    }
    const newUser = AuthUser(isEmailVerified: true, email: 'foo', id: 'my-id');
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}
