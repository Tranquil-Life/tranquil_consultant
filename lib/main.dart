import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tl_consultant/app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/message_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/video_call_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/growth_kit/presentation/controllers/growth_kit_controller.dart';
import 'package:tl_consultant/features/home/presentation/controllers/event_controller.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

import 'core/constants/constants.dart';
import 'features/activity/presentation/controllers/activity_controller.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/chat/presentation/controllers/upload_controller.dart';
import 'features/consultation/presentation/controllers/meetings_controller.dart';
import 'features/consultation/presentation/controllers/slot_controller.dart';
import 'features/home/presentation/controllers/home_controller.dart';
import 'features/journal/presentation/controllers/notes_controller.dart';
import 'features/media/presentation/controllers/video_recording_controller.dart';
import 'features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'features/settings/presentation/controllers/settings_controller.dart';
import 'features/wallet/presentation/controllers/earnings_controller.dart';
import 'features/wallet/presentation/controllers/transactions_controller.dart';

late List<CameraDescription> cameras;
PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
GetStorage storage = GetStorage();

final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
GlobalKey<ScaffoldMessengerState>();

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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🔕 Background message: $message");
  debugPrint("🔕 Background message title: ${message.notification?.title}");
  debugPrint("🔕 Background message body: ${message.notification?.body}");
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
  Get.put<ProfileController>(ProfileController());
  Get.put<OnboardingController>(OnboardingController());
  Get.put<AuthController>(AuthController());
  Get.put<DashboardController>(DashboardController());
  Get.put<ActivityController>(ActivityController());
  Get.put<HomeController>(HomeController());
  Get.put<EarningsController>(EarningsController());
  Get.put<TransactionsController>(TransactionsController());
  Get.put<NotesController>(NotesController());
  Get.put<SettingsController>(SettingsController());
  Get.put<EventsController>(EventsController());

  Get.put<MeetingsController>(MeetingsController());
  Get.put<SlotController>(SlotController());

  Get.put<ChatController>(ChatController());
  Get.put<VideoCallController>(VideoCallController());
  Get.put<MessageController>(MessageController());
  Get.put<UploadController>(UploadController());
  Get.put<VideoRecordingController>(VideoRecordingController());
  Get.put<NetworkController>(NetworkController());
  Get.put<GrowthKitController>(GrowthKitController());

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

  // await SentryFlutter.init(
  //       (options) {
  //     options.dsn = sentryDSN;
  //     options.tracesSampleRate = 1.0;
  //     options.profilesSampleRate = 1.0;
  //   },
  // );

  runApp(const App());
}

