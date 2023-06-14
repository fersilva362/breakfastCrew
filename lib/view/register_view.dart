import 'dart:js_interop';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                if (userCredential.isUndefinedOrNull) {
                  print("you're logged");
                }
              } on FirebaseAuthException catch (e) {
                print(e);
              }
            },
            child: const Text('REGISTER'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Click to SignIn'),
          ),
        ],
      ),
    );
  }
}
