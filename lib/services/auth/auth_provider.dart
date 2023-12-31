import 'package:user_app/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<void> initialize();
  Future<AuthUser> logIn({required String email, required String password});
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<AuthUser> createUser(
      {required String email, required String password});
  Future<void> sendPasswordReset({required String toEmail});
}
