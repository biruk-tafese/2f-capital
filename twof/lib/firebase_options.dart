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
    databaseURL: 'https://f-chat-todo-app-default-rtdb.firebaseio.com',
    storageBucket: 'f-chat-todo-app.appspot.com',
    measurementId: 'G-YBCRD8GFV8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9aAB3PlW0WhkHuNkkrdPZZgc6FgW1NYM',
    appId: '1:829710817758:android:e1dfd9b36f163c123ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    databaseURL: 'https://f-chat-todo-app-default-rtdb.firebaseio.com',
    storageBucket: 'f-chat-todo-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmOJIvGCqNjMOD0L-IpOad16lzsuqXUOk',
    appId: '1:829710817758:ios:8e5e0f2d21c79b123ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    databaseURL: 'https://f-chat-todo-app-default-rtdb.firebaseio.com',
    storageBucket: 'f-chat-todo-app.appspot.com',
    androidClientId: '829710817758-0bttb2u679pd010sl08h5n32dir80du9.apps.googleusercontent.com',
    iosClientId: '829710817758-bjk9i5n31i06ch2bh73std3d4f4lh1u4.apps.googleusercontent.com',
    iosBundleId: 'com.example.twof',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCmOJIvGCqNjMOD0L-IpOad16lzsuqXUOk',
    appId: '1:829710817758:ios:8e5e0f2d21c79b123ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    databaseURL: 'https://f-chat-todo-app-default-rtdb.firebaseio.com',
    storageBucket: 'f-chat-todo-app.appspot.com',
    androidClientId: '829710817758-0bttb2u679pd010sl08h5n32dir80du9.apps.googleusercontent.com',
    iosClientId: '829710817758-bjk9i5n31i06ch2bh73std3d4f4lh1u4.apps.googleusercontent.com',
    iosBundleId: 'com.example.twof',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD6Ekvdh8svzmcuShB1W5X60IALQ8XfkLk',
    appId: '1:829710817758:web:d8a9652b7da4019d3ea54f',
    messagingSenderId: '829710817758',
    projectId: 'f-chat-todo-app',
    authDomain: 'f-chat-todo-app.firebaseapp.com',
    databaseURL: 'https://f-chat-todo-app-default-rtdb.firebaseio.com',
    storageBucket: 'f-chat-todo-app.appspot.com',
    measurementId: 'G-0KL5DWMC3J',
  );
}