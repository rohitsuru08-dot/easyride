import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzp1tE1KSI9FhpEBEW838ptN_moKFqNOA',
    appId: '1:832583492226:android:4e837db22cb1fef9630a9b',
    messagingSenderId: '832583492226',
    projectId: 'easyride-81df0',
    storageBucket: 'easyride-81df0.firebasestorage.app',
  );

  // Fill in after adding an iOS app in Firebase Console → Project Settings → Your apps
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '832583492226',
    projectId: 'easyride-81df0',
    storageBucket: 'easyride-81df0.firebasestorage.app',
    iosBundleId: 'com.apsrtc.easyride',
  );

  // Fill in after adding a Web app in Firebase Console → Project Settings → Your apps → Add app → Web
  // Copy apiKey and appId from the "firebaseConfig" snippet shown there.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDV5DfDwNki4loV6tVgC7jSxvOgTzhoPyk',
    appId: '1:832583492226:web:ca16a950e54f644c630a9b',
    messagingSenderId: '832583492226',
    projectId: 'easyride-81df0',
    authDomain: 'easyride-81df0.firebaseapp.com',
    storageBucket: 'easyride-81df0.firebasestorage.app',
  );
}
