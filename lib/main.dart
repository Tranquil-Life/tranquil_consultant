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
import 'package:tl_consultant/app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

late List<CameraDescription> cameras;
PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // Register before running the app
  Get.put(ProfileController());


  try {
    await Firebase.initializeApp();
  } catch (e) {
    // print('Firebase init failed: $e');
  }

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

  runApp(const App());
}

