import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/services/auth/bloc/auth_bloc.dart';
import 'package:user_app/services/auth/bloc/auth_event.dart';

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
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventSenEmailVerification(),
                  );
            },
            child: const Text('sent Email'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('login'))
        ],
      ),
    );
  }
}
