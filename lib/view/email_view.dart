import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Email extends StatefulWidget {
  const Email({super.key});

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Column(
        children: [
          const Text('You have not validate your email'),
          TextButton(
            onPressed: () async {
              final emailValidate = FirebaseAuth.instance.currentUser;
              await emailValidate?.sendEmailVerification();
            },
            child: const Text('sent Email'),
          ),
        ],
      ),
    );
  }
}
