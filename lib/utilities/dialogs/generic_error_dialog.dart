import 'package:flutter/material.dart';
import 'package:user_app/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'an error has ocurred',
    content: text,
    optionsBuilder: () => {'OK': null},
  ).then((value) => value ?? false);
}
