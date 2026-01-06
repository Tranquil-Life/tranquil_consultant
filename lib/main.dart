import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:tl_consultant/app.dart';

// controllers...
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/home/presentation/controllers/home_controller.dart';
import 'package:tl_consultant/features/home/presentation/controllers/event_controller.dart';
import 'package:tl_consultant/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/transactions_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/slot_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/video_call_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/message_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/upload_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/growth_kit/presentation/controllers/growth_kit_controller.dart';

PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
GetStorage storage = GetStorage();

Future<void> initializeFirebaseWeb() async {
  await Firebase.initializeApp(
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
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Needed on mobile background isolate:
  await Firebase.initializeApp();
  debugPrint("🔕 Background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1) init Firebase ONCE
  if (Firebase.apps.isEmpty) {
    if (kIsWeb) {
      await initializeFirebaseWeb();
    } else {
      await Firebase.initializeApp();
    }
  }

  // ✅ 2) init GetStorage BEFORE any controller is created
  await GetStorage.init();

  // ✅ 3) timezone
  tz.initializeTimeZones();

  // ✅ 4) FCM: web vs mobile differences
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  } else {
    // On web, permission/token flow differs; token may require vapidKey.
    // FirebaseMessaging.instance.getToken(vapidKey: 'YOUR_WEB_PUSH_CERTIFICATE_KEY');
  }

  // ✅ 5) Put controllers ONCE (remove duplicates)
  Get.put(ProfileController());
  Get.put(OnboardingController());
  Get.put(AuthController());
  Get.put(DashboardController());
  Get.put(ActivityController());
  Get.put(HomeController());
  Get.put(EarningsController());
  Get.put(TransactionsController());
  Get.put(NotesController());
  Get.put(SettingsController());
  Get.put(EventsController());
  Get.put(MeetingsController());
  Get.put(SlotController());
  Get.put(ChatController());
  Get.put(VideoCallController());
  Get.put(MessageController());
  Get.put(UploadController());
  Get.put(VideoRecordingController());
  Get.put(NetworkController());
  Get.put(GrowthKitController());

  runApp(const App());
}
