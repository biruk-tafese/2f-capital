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
    apiKey: 'AIzaSyD6Ekvdh8svzmcuShB1W5X60IALQ8XfkLk',
    appId: '1:829710817758:web:42be87581ebed77a3ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    authDomain: 'f-chat-todo-app.firebaseapp.com',
    storageBucket: 'f-chat-todo-app.appspot.com',
    measurementId: 'G-YBCRD8GFV8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9aAB3PlW0WhkHuNkkrdPZZgc6FgW1NYM',
    appId: '1:829710817758:android:e1dfd9b36f163c123ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    storageBucket: 'f-chat-todo-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmOJIvGCqNjMOD0L-IpOad16lzsuqXUOk',
    appId: '1:829710817758:ios:1cfed8acae4ee5f03ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    storageBucket: 'f-chat-todo-app.appspot.com',
    iosBundleId: 'com.example.todochatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmOJIvGCqNjMOD0L-IpOad16lzsuqXUOk',
    appId: '1:829710817758:ios:1cfed8acae4ee5f03ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    storageBucket: 'f-chat-todo-app.appspot.com',
    iosBundleId: 'com.example.todochatapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD6Ekvdh8svzmcuShB1W5X60IALQ8XfkLk',
    appId: '1:829710817758:web:93354931c4882d743ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    authDomain: 'f-chat-todo-app.firebaseapp.com',
    storageBucket: 'f-chat-todo-app.appspot.com',
    measurementId: 'G-9EP1XS5FPR',
  );
}
