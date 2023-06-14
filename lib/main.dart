import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_app/view/email_view.dart';
//import 'package:user_app/view/email_view.dart';
import 'package:user_app/view/login_view.dart';
import 'package:user_app/view/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
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
            if (user?.emailVerified ?? false) {
              print('>>>>User with email succesfully verified<<<<');
              return const LoginView();
            } else {
              print(user);
              return const Email();
            }
          default:
            return const Text('loading');
        }
      },
    );
  }
}
