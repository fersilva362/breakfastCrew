import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_app/constant/routes.dart';

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
          const Text("We've send you an email. Check your email box"),
          const SizedBox(
            height: 20.0,
          ),
          const Text('If you  have not receive it  your email'),
          TextButton(
            onPressed: () async {
              final emailValidate = FirebaseAuth.instance.currentUser;
              await emailValidate?.sendEmailVerification();
            },
            child: const Text('sent Email'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, registerRoute, (route) => false);
                }
              },
              child: const Text('login'))
        ],
      ),
    );
  }
}
