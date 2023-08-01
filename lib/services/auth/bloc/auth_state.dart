import 'package:user_app/services/auth/auth_user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateFailureLoggedOut extends AuthState {
  final Exception exception;

  AuthStateFailureLoggedOut(this.exception);
}

class AuthStateNeedsEmailVerification extends AuthState {
  const AuthStateNeedsEmailVerification();
}
