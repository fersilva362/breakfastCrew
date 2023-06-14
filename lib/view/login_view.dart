import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _email;
  late TextEditingController _password;
  String finalWord = 'tatatt';
  /* final Future _data = Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCSs8xEwHeOEVz-87ECTfNUmO8ZKAQS8Ew",
        appId: "1:995918257203:web:87dfb0f79391dee26b1746",
        messagingSenderId: "995918257203",
        projectId: "user-app-fersilva362-1369"),
  ); */
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
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                if (userCredential.isDefinedAndNotNull) {
                  print(FirebaseAuth.instance.currentUser?.emailVerified ??
                      false);
                }
              } on FirebaseAuthException catch (e) {
                print(e);
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register', (route) => false);
            },
            child: const Text('Click here to register'),
          ),
        ],
      ),
    );
  }
}
