import 'package:equatable/equatable.dart';
import 'package:user_app/services/auth/auth_user.dart';

abstract class AuthState {
  final bool isLoading;
  final String? isLoadingText;
  const AuthState(
      {required this.isLoading, this.isLoadingText = 'Please wait a moment'});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  AuthStateRegistering({required bool isLoading, this.exception})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;

  const AuthStateLoggedOut({
    required this.exception,
    required isLoading,
    String? isLoadingText,
  }) : super(
          isLoading: isLoading,
          isLoadingText: isLoadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateNeedsEmailVerification extends AuthState {
  const AuthStateNeedsEmailVerification({required bool isLoading})
      : super(isLoading: isLoading);
}
