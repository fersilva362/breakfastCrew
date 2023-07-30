import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/constant/routes.dart';
import 'package:user_app/services/auth/auth_service.dart';
import 'package:user_app/services/auth/bloc/auth_bloc.dart';
import 'package:user_app/services/auth/bloc/auth_event.dart';
import 'package:user_app/services/cloud/firebase_cloud_storage.dart';
import 'package:user_app/view/note/note_list_view.dart';
import 'dart:developer' as devtools show log;
import '../../constant/enums.dart';
import '../../services/cloud/cloud_note.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
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
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final dataShow = await showLogOutDialog(context);
                    if (dataShow && context.mounted) {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );

                      /* await AuthService.firebase().logOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          loginRoute,
                          (route) => false,
                        );
                      } */
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
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNote = snapshot.data as Iterable<CloudNote>;
                devtools.log(allNote.toString());
                return NoteListView(
                  notes: allNote,
                  onDeleteNote: (CloudNote note) async {
                    await _noteService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (CloudNote note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const Text('snapshot hasnt data');
              }

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