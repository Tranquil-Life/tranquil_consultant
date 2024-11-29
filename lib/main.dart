import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tl_consultant/app.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const App());

  tz.initializeTimeZones();

  await Future.wait([
    if (kIsWeb)
      Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDvEsztETqHYAwfJx0ocpjPTZccMNDMc-k",
          authDomain: "tranquil-life-llc.firebaseapp.com",
          databaseURL: "https://tranquil-life-llc-default-rtdb.firebaseio.com",
          projectId: "tranquil-life-llc",
          storageBucket: "tranquil-life-llc.appspot.com",
          messagingSenderId: "16125004014",
          appId: "1:16125004014:web:1a1ccb278c740a6d5f8bff",
          measurementId: "G-ZRTEN0GQKV",
        ),
      )
    else
      Firebase.initializeApp(),
  ]);

  // firebaseFireStore = FirebaseFirestore.instance
  //   ..settings = const Settings(persistenceEnabled: true);
}
