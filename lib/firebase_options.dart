// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
// import 'firebase_options.dart';
/// // ...
// await Firebase.initializeApp(
//    options: DefaultFirebaseOptions.currentPlatform,
//  );
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD7CvcZAD85CS7NYvlc64sR8h3QBB0faOg',
    appId: '1:158174064876:web:76de8c0cf224359fe7f5c9',
    messagingSenderId: '158174064876',
    projectId: 'nhm-kozhikode',
    authDomain: 'nhm-kozhikode.firebaseapp.com',
    storageBucket: 'nhm-kozhikode.appspot.com',
    measurementId: 'G-BG8ZG9207P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwekOuZZffC4i6JVHIrTkfk_TAWu7OcfQ',
    appId: '1:158174064876:android:892935b2a4389cd4e7f5c9',
    messagingSenderId: '158174064876',
    projectId: 'nhm-kozhikode',
    storageBucket: 'nhm-kozhikode.appspot.com',
  );
}