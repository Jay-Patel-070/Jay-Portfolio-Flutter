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
        return windows;
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
    apiKey: 'AIzaSyBlEgqXgH8fR0kGwo9I7oxnyPya6Hs__2A',
    appId: '1:98225831516:web:104a34dc9ea935cc34f099',
    messagingSenderId: '98225831516',
    projectId: 'jay-software-engineer',
    authDomain: 'jay-software-engineer.firebaseapp.com',
    storageBucket: 'jay-software-engineer.firebasestorage.app',
    measurementId: 'G-VK3SLEJ3BR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkBet6jWjXRGGHZ2dyJHsTSR0xeZRiNhI',
    appId: '1:98225831516:android:5ba463ede81d9edf34f099',
    messagingSenderId: '98225831516',
    projectId: 'jay-software-engineer',
    storageBucket: 'jay-software-engineer.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUCvm4CtDDE7WC6RBh5HVOnYi1z-osHSo',
    appId: '1:98225831516:ios:44220d10815da85634f099',
    messagingSenderId: '98225831516',
    projectId: 'jay-software-engineer',
    storageBucket: 'jay-software-engineer.firebasestorage.app',
    iosBundleId: 'com.example.jaySoftwareEngineer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUCvm4CtDDE7WC6RBh5HVOnYi1z-osHSo',
    appId: '1:98225831516:ios:44220d10815da85634f099',
    messagingSenderId: '98225831516',
    projectId: 'jay-software-engineer',
    storageBucket: 'jay-software-engineer.firebasestorage.app',
    iosBundleId: 'com.example.jaySoftwareEngineer',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBlEgqXgH8fR0kGwo9I7oxnyPya6Hs__2A',
    appId: '1:98225831516:web:104a34dc9ea935cc34f099',
    messagingSenderId: '98225831516',
    projectId: 'jay-software-engineer',
    authDomain: 'jay-software-engineer.firebaseapp.com',
    storageBucket: 'jay-software-engineer.firebasestorage.app',
    measurementId: 'G-VK3SLEJ3BR',
  );

}