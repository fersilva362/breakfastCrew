import 'package:user_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want logout',
    optionsBuilder: () => {
      'cancel': false,
      'logout': true,
    },
  ).then((value) => value ?? false);
}

/* Future<bool> showLogOutDialog(context) {
  return showDialog<bool>(
    context: context,
    builder: (context) =>
        AlertDialog(title: const Text('What do you want?'), actions: [
      TextButton(
          onPressed: () {
            devtools.log('click cancel');
            Navigator.pop(context, false);
          },
          child: const Text('cancel')),
      TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('logout'))
    ]),
  ).then((value) => value ?? false);
} */
