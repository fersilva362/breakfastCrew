// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCSs8xEwHeOEVz-87ECTfNUmO8ZKAQS8Ew',
    appId: '1:995918257203:web:87dfb0f79391dee26b1746',
    messagingSenderId: '995918257203',
    projectId: 'user-app-fersilva362-1369',
    authDomain: 'user-app-fersilva362-1369.firebaseapp.com',
    storageBucket: 'user-app-fersilva362-1369.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9SO2uzVv4XxodggPNfuG_QZLQMx-ciHg',
    appId: '1:995918257203:android:8a4c7b03eb7f89da6b1746',
    messagingSenderId: '995918257203',
    projectId: 'user-app-fersilva362-1369',
    storageBucket: 'user-app-fersilva362-1369.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFE3zNBeHsQ0i81Gp2rhOGztg9jJSsn8c',
    appId: '1:995918257203:ios:8a15b35518068e156b1746',
    messagingSenderId: '995918257203',
    projectId: 'user-app-fersilva362-1369',
    storageBucket: 'user-app-fersilva362-1369.appspot.com',
    iosClientId: '995918257203-44idf0vnva1f3q9i6er4rb0qlqsjkjqo.apps.googleusercontent.com',
    iosBundleId: 'com.example.userApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBFE3zNBeHsQ0i81Gp2rhOGztg9jJSsn8c',
    appId: '1:995918257203:ios:c98f79a1381d0e296b1746',
    messagingSenderId: '995918257203',
    projectId: 'user-app-fersilva362-1369',
    storageBucket: 'user-app-fersilva362-1369.appspot.com',
    iosClientId: '995918257203-htmv7chd3o0p80m6p23j38gmrdh2v3qf.apps.googleusercontent.com',
    iosBundleId: 'com.example.userApp.RunnerTests',
  );
}
