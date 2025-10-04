import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tl_consultant/app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

import 'core/constants/constants.dart';

late List<CameraDescription> cameras;
PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

Future<void> initializeFirebase() async {
  FirebaseApp app = await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: "1:16125004014:web:1a1ccb278c740a6d5f8bff",
      apiKey: "AIzaSyDvEsztETqHYAwfJx0ocpjPTZccMNDMc-k",
      projectId: 'tranquil-life-llc',
      messagingSenderId: '16125004014',
      databaseURL: "https://tranquil-life-llc-default-rtdb.firebaseio.com",
      measurementId: "G-ZRTEN0GQKV",
      storageBucket: "tranquil-life-llc.appspot.com",
      authDomain: "tranquil-life-llc.firebaseapp.com",
    ),
  );
  print('Initialized default app $app');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    if (kIsWeb) {
      await initializeFirebase();
    } else {
      await Firebase.initializeApp();
    }
  }


  await Firebase.initializeApp();

  tz.initializeTimeZones(); //for timezone initialization

  // Register before running the app
  Get.put(ProfileController());

  // Listen for messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print('Message received: ${message.notification?.title}');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // print('Notification clicked: ${message.notification?.title}');
  });

  try {
    cameras = await availableCameras()
        .timeout(Duration(seconds: 5), onTimeout: () {
      // print('Camera detection timed out');
      return [];
    });
    // print('Cameras found: ${cameras.length}');
  } catch (e) {
    // print('Camera init failed: $e');
    cameras = [];
  }

  await GetStorage.init();

  await SentryFlutter.init(
        (options) {
      options.dsn = sentryDSN;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
  );

  runApp(const App());
}

