import 'package:flutter/material.dart';
import 'package:user_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Individual Note',
    content: 'Do you really want to delete the note',
    optionsBuilder: () => {'No': false, 'delete': true},
  ).then((value) => value ?? false);
}
