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
    apiKey: 'AIzaSyADJpj903l6ymXiVE5MfVAyKzjcJvItedg',
    appId: '1:406451965922:web:c9a7d0aa395709d6f1b3bb',
    messagingSenderId: '406451965922',
    projectId: 'moneymanagement-338ba',
    authDomain: 'moneymanagement-338ba.firebaseapp.com',
    storageBucket: 'moneymanagement-338ba.appspot.com',
    measurementId: 'G-MBS7MHWNNZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6zfjXc7SJqGtiQ0h6Y1wzwFSJKz9BXp4',
    appId: '1:406451965922:android:96df519b7e17dc60f1b3bb',
    messagingSenderId: '406451965922',
    projectId: 'moneymanagement-338ba',
    storageBucket: 'moneymanagement-338ba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-lGnan5yaM6Y5iboeFaoHylv0jfawNZI',
    appId: '1:406451965922:ios:2ef34a9bd44e9887f1b3bb',
    messagingSenderId: '406451965922',
    projectId: 'moneymanagement-338ba',
    storageBucket: 'moneymanagement-338ba.appspot.com',
    iosBundleId: 'com.example.moneyManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-lGnan5yaM6Y5iboeFaoHylv0jfawNZI',
    appId: '1:406451965922:ios:c7479b30d8a58870f1b3bb',
    messagingSenderId: '406451965922',
    projectId: 'moneymanagement-338ba',
    storageBucket: 'moneymanagement-338ba.appspot.com',
    iosBundleId: 'com.example.moneyManagement.RunnerTests',
  );
}