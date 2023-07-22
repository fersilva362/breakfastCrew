import 'package:flutter/material.dart';
import 'package:user_app/constant/routes.dart';
import 'package:user_app/services/auth/auth_service.dart';
import 'package:user_app/services/note_service.dart';
import 'package:user_app/view/note/note_list_view.dart';
import 'dart:developer' as devtools show log;
import '../../constant/enums.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _noteService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteView'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newViewRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final dataShow = await showLogOutDialog(context);
                    if (dataShow) {
                      await AuthService.firebase().logOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          loginRoute,
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
                  ])
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(
          email: userEmail,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      devtools
                          .log('snapshotOfStream.hasData and is: $snapshot');
                      if (snapshot.hasData) {
                        final allNote = snapshot.data as List<DatabaseNote>;

                        return NoteListView(
                          notes: allNote,
                          onDeleteNote: (DatabaseNote note) async {
                            await _noteService.deleteNote(id: note.id);
                          },
                        );
                      } else {
                        return const Text('snapshot hasnt data');
                      }

                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
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
}
 */