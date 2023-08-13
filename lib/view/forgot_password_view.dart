import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/services/auth/bloc/auth_bloc.dart';
import 'package:user_app/services/auth/bloc/auth_event.dart';
import 'package:user_app/services/auth/bloc/auth_state.dart';
import 'package:user_app/utilities/dialogs/generic_error_dialog.dart';
import 'package:user_app/utilities/dialogs/passord_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            return await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            return showErrorDialog(context,
                'We could not process your request, check if you are a register user');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Password Reset')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'If you forgot your password, enter your email and click'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration:
                    const InputDecoration(hintText: 'Your email adrress...'),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                child: const Text('Send me password reset link'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Back to Login Page'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
