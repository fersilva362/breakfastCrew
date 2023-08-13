import 'package:flutter/material.dart';
import 'package:user_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'We have now sent a reset password link. Please check your email inbox',
    optionsBuilder: () => {'OK': null},
  );
}
