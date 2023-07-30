import 'package:flutter/material.dart';
import 'package:user_app/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNote({required BuildContext context}) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note',
    optionsBuilder: () {
      return {'Ok': null};
    },
  );
}
