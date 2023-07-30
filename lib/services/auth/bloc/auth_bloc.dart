import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/services/auth/auth_provider.dart';
import 'package:user_app/services/auth/bloc/auth_event.dart';
import 'package:user_app/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(null),
          );
        } else if (!user.isEmailVerified) {
          emit(
            const AuthStateNeedsEmailVerification(),
          );
        } else {
          emit(
            AuthStateLoggedIn(user),
          );
        }
      },
    );
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(
          AuthStateLoggedIn(user),
        );
      } on Exception catch (e) {
        emit(
          AuthStateFailureLogIn(e),
        );
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(
          AuthStateFailureLoggedOut(e),
        );
      }
    });
  }
}