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
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/app_config.dart';
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

GetStorage storage = GetStorage();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🔕 Background message title: ${message.notification?.title}");
  debugPrint("🔕 Background message body: ${message.notification?.body}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init storage first
  await GetStorage.init();

  // Init Firebase once
  if (kIsWeb) {
    await initializeFirebase(); // must include correct FirebaseOptions
  } else {
    await Firebase.initializeApp();
  }

  // Request permission
  final settings = await FirebaseMessaging.instance.requestPermission();
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  // Web token needs VAPID key
  final token = await FirebaseMessaging.instance.getToken(
    vapidKey: kIsWeb ? AppConfig.fcmWebVapidKey : null,
  );
  debugPrint('Firebase messaging token: $token');

  // Background handler (mobile only)
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');

    final title = message.notification?.title ?? 'Tranquil Life';
    final body = message.notification?.body ?? '';

    CustomSnackBar.showSnackBar(
        context: Get.context!,
        title: title,
        message: body,
        backgroundColor: ColorPalette.blue,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5));

  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('Notification clicked: ${message.notification?.title}');
  });

  // Controllers (avoid duplicates)
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

  if(!kIsWeb){
    tz.initializeTimeZones();
  }

  // Cameras (optional)
  try {
    cameras = await availableCameras()
        .timeout(const Duration(seconds: 5), onTimeout: () => []);
  } catch (_) {
    cameras = [];
  }

  // Sentry init (make sure you use appRunner)
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDSN;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(const App()),
  );
}
