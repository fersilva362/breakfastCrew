import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/services/auth/bloc/auth_bloc.dart';
import 'package:user_app/services/auth/bloc/auth_event.dart';
import 'package:user_app/services/auth/bloc/auth_state.dart';
import 'package:user_app/utilities/dialogs/generic_error_dialog.dart';
import 'package:user_app/services/auth/auth_exceptions.dart';
import 'dart:developer' as devtool show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _email;
  late TextEditingController _password;
  //CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthExceptions) {
            await showErrorDialog(context, 'error: User Not Found');
          } else if (state.exception is WrongPasswordAuthExceptions) {
            await showErrorDialog(context, 'error: Worng Credentials');
          } else if (state.exception is GenericAuthExceptions) {
            await showErrorDialog(context, 'error: Authentication Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page '),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: _email,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  label: const Text('Email'),
                  hintText: 'Please introduce your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true,
                controller: _password,
                decoration: InputDecoration(
                  label: const Text('Password'),
                  hintText: 'Please introduce your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
                child: const Text('Click here reset password'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text('Click here to register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
