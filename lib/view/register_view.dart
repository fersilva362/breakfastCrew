import 'dart:developer' as devtools show log;
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:user_app/constant/dialogs.dart';
import 'package:user_app/constant/routes.dart';
import 'package:user_app/services/auth/auth_exceptions.dart';
import 'package:user_app/services/auth/auth_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          TextField(
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
              try {
                final email = _email.text;
                final password = _password.text;
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                await AuthService.firebase().sendEmailVerification();

                if (context.mounted) {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
              } on UserNotFoundAuthExceptions {
                mostrarAlerta(
                  context,
                  'Error: User Not Found',
                );
              } on WeakPassWordAuthExceptions {
                mostrarAlerta(
                  context,
                  'Error: Weak Password',
                );
              } on EmailAlreadyInUseAuthExceptions {
                mostrarAlerta(
                  context,
                  'Error: Email Already In Use',
                );
              } on InvalidEmailAuthExceptions {
                mostrarAlerta(
                  context,
                  'Error: Invalid Email Format',
                );
              } on GenericAuthExceptions {
                mostrarAlerta(
                  context,
                  'Error: Error in Authentication',
                );
              }
            },
            child: const Text('REGISTER'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Click to SignIn'),
          ),
        ],
      ),
    );
  }
}
