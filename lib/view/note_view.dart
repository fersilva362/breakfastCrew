// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout }

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteView'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final dataShow = await mostrarMeDialogo(context);
                  if (dataShow) {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  }
                  break;
                default:
                  devtools.log('default');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: MenuAction.logout, child: Text('logout')),
            ],
          )
        ],
      ),
    );
  }
}

Future<bool> mostrarMeDialogo(context) {
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
            devtools.log('click logout');
          },
          child: const Text('logout'))
    ]),
  ).then((value) => value ?? false);
}
