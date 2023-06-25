import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_app/view/email_view.dart';
//import 'package:user_app/view/email_view.dart';
import 'package:user_app/view/login_view.dart';
import 'package:user_app/view/register_view.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
    },
    home: const HomePage(),
    //register: fer@unc.com pass=tester1
  ));
}

final Future _data = Firebase.initializeApp(
  options: const FirebaseOptions(
      apiKey: "AIzaSyCSs8xEwHeOEVz-87ECTfNUmO8ZKAQS8Ew",
      appId: "1:995918257203:web:87dfb0f79391dee26b1746",
      messagingSenderId: "995918257203",
      projectId: "user-app-fersilva362-1369"),
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  /* atenttion to error The following FirebaseException was thrown building FutureBuilder<dynamic>(dirty, state:
_FutureBuilderState<dynamic>#2ec19):
[core/not-initialized] Firebase has not been correctly initialized. */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        final user = FirebaseAuth.instance.currentUser;
        //print(user);

        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (user != null) {
              if (user.emailVerified) {
                devtools.log('emailVerified=${user.emailVerified.toString()}');

                return const NotesView();
              } else {
                return const Email();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

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
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
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
