// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyBxVCp0y70BjmmcQyrCyG_x-TkgiHHXQJk',
    appId: '1:532609230646:web:3be65218c3e965d7f0f597',
    messagingSenderId: '532609230646',
    projectId: 'studybuds-116d5',
    authDomain: 'studybuds-116d5.firebaseapp.com',
    storageBucket: 'studybuds-116d5.firebasestorage.app',
    measurementId: 'G-M122EG465D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAB0T_5QlDbGGY-tkFlj3Pasdqf_QGlMCs',
    appId: '1:532609230646:android:1c34057810d79885f0f597',
    messagingSenderId: '532609230646',
    projectId: 'studybuds-116d5',
    storageBucket: 'studybuds-116d5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDVFKUR8TnB55yhfdNXa_37ZVCRx9jU-ZY',
    appId: '1:532609230646:ios:7a88f65088f2d6a9f0f597',
    messagingSenderId: '532609230646',
    projectId: 'studybuds-116d5',
    storageBucket: 'studybuds-116d5.firebasestorage.app',
    iosBundleId: 'com.orange.studybuds',
  );

}