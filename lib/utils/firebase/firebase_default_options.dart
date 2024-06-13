// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_default_options.dart';
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
    apiKey: 'AIzaSyBW0pHYpXCdttMnV9FhX59ao4XuxY0G7fA',
    appId: '1:150694088229:web:477c3afd623e6c7dbcb9cc',
    messagingSenderId: '150694088229',
    projectId: 'flukefy-76608',
    authDomain: 'flukefy-76608.firebaseapp.com',
    storageBucket: 'flukefy-76608.appspot.com',
    measurementId: 'G-7Z1V0488VH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnv678MGTnXa4CHzGJy-Hcu9jmPcqyTss',
    appId: '1:150694088229:android:f4cdeff052945ec7bcb9cc',
    messagingSenderId: '150694088229',
    projectId: 'flukefy-76608',
    storageBucket: 'flukefy-76608.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgkDcI_Sw7skGPzXNu2Q9ZzTQkp4-OLmM',
    appId: '1:150694088229:ios:6f1056265b552a19bcb9cc',
    messagingSenderId: '150694088229',
    projectId: 'flukefy-76608',
    storageBucket: 'flukefy-76608.appspot.com',
    androidClientId: '150694088229-a82a8ah2cllu79cjnkpe150pf6gah764.apps.googleusercontent.com',
    iosClientId: '150694088229-kri6ovf0f8nrchl69l0jcl2c1ecjf8tl.apps.googleusercontent.com',
    iosBundleId: 'com.shamil.flukefy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgkDcI_Sw7skGPzXNu2Q9ZzTQkp4-OLmM',
    appId: '1:150694088229:ios:8897bb37a7e63029bcb9cc',
    messagingSenderId: '150694088229',
    projectId: 'flukefy-76608',
    storageBucket: 'flukefy-76608.appspot.com',
    androidClientId: '150694088229-a82a8ah2cllu79cjnkpe150pf6gah764.apps.googleusercontent.com',
    iosClientId: '150694088229-9evio4p8sso82q2efjtnpc3sbe0ciiq9.apps.googleusercontent.com',
    iosBundleId: 'com.shamil.flukefy.RunnerTests',
  );
}