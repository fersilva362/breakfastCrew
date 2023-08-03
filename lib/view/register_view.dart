import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/services/auth/auth_exceptions.dart';
import 'dart:developer' as devtool show log;
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/generic_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController _email;
  late TextEditingController _password;
  String finalWord = 'tatatt';

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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPassWordAuthExceptions) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthExceptions) {
            await showErrorDialog(context, 'Email Already In Use');
          } else if (state.exception is InvalidEmailAuthExceptions) {
            showErrorDialog(
              context,
              'Error: Invalid Email Format',
            );
          } else if (state.exception is GenericAuthExceptions) {
            showErrorDialog(
              context,
              'Error in Authentication',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register Page'),
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
                  label: const Text('Pasword'),
                  hintText: 'Please introduce your pasword',
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
                        AuthEventRegister(
                          email: email,
                          password: password,
                        ),
                      );
                  devtool.log('click');
                },
                child: const Text('REGISTER'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text('Click to SignIn'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
