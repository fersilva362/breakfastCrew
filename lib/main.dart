//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_app/constant/routes.dart';
import 'package:user_app/services/auth/auth_service.dart';
import 'package:user_app/view/email_view.dart';
import 'package:user_app/view/login_view.dart';
import 'package:user_app/view/note/create_update_note_view.dart';
import 'package:user_app/view/note/notes_view.dart';
import 'package:user_app/view/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//AuthService.firebase().initialize();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      noteRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const Email(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
    home: const HomePage(),
    //register: fer@unc.com pass=tester1
  ));
}

final Future _data = AuthService.firebase().initialize();
/* Firebase.initializeApp(
  options: const FirebaseOptions(
      apiKey: "AIzaSyCSs8xEwHeOEVz-87ECTfNUmO8ZKAQS8Ew",
      appId: "1:995918257203:web:87dfb0f79391dee26b1746",
      messagingSenderId: "995918257203",
      projectId: "user-app-fersilva362-1369"),
); */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (context, snapshot) {
        final user = AuthService.firebase().currentUser;
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (user != null) {
              if (user.isEmailVerified) {
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
