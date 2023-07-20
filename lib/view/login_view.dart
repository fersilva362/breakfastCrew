import 'package:flutter/material.dart';
import 'package:user_app/constant/dialogs.dart';
import 'package:user_app/constant/routes.dart';
import 'package:user_app/services/auth/auth_exceptions.dart';
import 'package:user_app/services/auth/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login Page '),
        centerTitle: true,
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
              label: const Text('Password'),
              hintText: 'Please introduce your password',
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
                    .logIn(email: email, password: password);

                final user = AuthService.firebase().currentUser;
                final userWithMailVerify = user?.isEmailVerified ?? false;

                if (userWithMailVerify && context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, noteRoute, (route) => false);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, verifyEmailRoute, (route) => false);
                }
              } on UserNotFoundAuthExceptions {
                await mostrarAlerta(context, 'error: User Not Found');
              } on WrongPasswordAuthExceptions {
                await mostrarAlerta(context, 'error: Worng Credentials');
              } on GenericAuthExceptions {
                await mostrarAlerta(context, 'error: Authentication Error');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Click here to register'),
          ),
        ],
      ),
    );
  }
}
