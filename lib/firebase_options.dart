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
    apiKey: 'AIzaSyAmldwmC1fkMIiXpWsRZ69TQc29q5isEcg',
    appId: '1:567146583861:web:ced51e128aec2e68bb5e7c',
    messagingSenderId: '567146583861',
    projectId: 'taskmanager-5f76b',
    authDomain: 'taskmanager-5f76b.firebaseapp.com',
    storageBucket: 'taskmanager-5f76b.appspot.com',
    measurementId: 'G-EQGW9YZN0D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDotEqXi36uKhuqGI1FehgQIC6O_DzU_BY',
    appId: '1:567146583861:android:40ab1b41abdb293abb5e7c',
    messagingSenderId: '567146583861',
    projectId: 'taskmanager-5f76b',
    storageBucket: 'taskmanager-5f76b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJQwdp6sxsK17a9o9SNipWAowNZ9a2F2c',
    appId: '1:567146583861:ios:caee4bfc2be7ee86bb5e7c',
    messagingSenderId: '567146583861',
    projectId: 'taskmanager-5f76b',
    storageBucket: 'taskmanager-5f76b.appspot.com',
    iosClientId: '567146583861-h2t0e5cgoebbndnk7ouse67iae0b52p3.apps.googleusercontent.com',
    iosBundleId: 'com.neto.alvaro.taskManager',
  );
}
