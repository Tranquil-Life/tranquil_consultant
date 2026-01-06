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

final kWebVapidKey =
    "BLxdS76FOWPNMjTrvZFe15VTPHbjqtrw-SybQKXVLr4YaVgNJK7X1YykxeEn0ery-wjMUunVBtou7xyPo3eDqIA";

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🔕 Background message title: ${message.notification?.title}");
  debugPrint("🔕 Background message body: ${message.notification?.body}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Firebase
  if (kIsWeb) {
    await initializeFirebase();
  } else {
    await Firebase.initializeApp();
  }

  // Controllers (register ONCE)
  void registerControllers() {
    if (!Get.isRegistered<ProfileController>()) Get.put(ProfileController());
    if (!Get.isRegistered<OnboardingController>()) Get.put(OnboardingController());
    if (!Get.isRegistered<AuthController>()) Get.put(AuthController());
    if (!Get.isRegistered<DashboardController>()) Get.put(DashboardController());
    if (!Get.isRegistered<ActivityController>()) Get.put(ActivityController());
    if (!Get.isRegistered<HomeController>()) Get.put(HomeController());
    if (!Get.isRegistered<EarningsController>()) Get.put(EarningsController());
    if (!Get.isRegistered<TransactionsController>()) Get.put(TransactionsController());
    if (!Get.isRegistered<NotesController>()) Get.put(NotesController());
    if (!Get.isRegistered<SettingsController>()) Get.put(SettingsController());
    if (!Get.isRegistered<EventsController>()) Get.put(EventsController());
    if (!Get.isRegistered<MeetingsController>()) Get.put(MeetingsController());
    if (!Get.isRegistered<SlotController>()) Get.put(SlotController());
    if (!Get.isRegistered<ChatController>()) Get.put(ChatController());
    if (!Get.isRegistered<VideoCallController>()) Get.put(VideoCallController());
    if (!Get.isRegistered<MessageController>()) Get.put(MessageController());
    if (!Get.isRegistered<UploadController>()) Get.put(UploadController());
    if (!Get.isRegistered<VideoRecordingController>()) Get.put(VideoRecordingController());
    if (!Get.isRegistered<NetworkController>()) Get.put(NetworkController());
    if (!Get.isRegistered<GrowthKitController>()) Get.put(GrowthKitController());
  }

  tz.initializeTimeZones();

  // Messaging (don’t use Get.context! here)
  final settings = await FirebaseMessaging.instance.requestPermission();
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  final token = await FirebaseMessaging.instance.getToken(
    vapidKey: kIsWeb ? kWebVapidKey : null,
  );
  debugPrint('Firebase messaging token: $token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final title = message.notification?.title ?? 'Tranquil Life';
    final body = message.notification?.body ?? '';

    // ✅ No BuildContext needed
    Get.snackbar(title, body, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5));
  });

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  try {
    cameras = await availableCameras()
        .timeout(const Duration(seconds: 5), onTimeout: () => []);
  } catch (_) {
    cameras = [];
  }

  registerControllers();

  // ✅ ONE Sentry init, always start app even if Sentry fails/blocked
  try {
    await SentryFlutter.init(
          (options) {
        options.dsn = sentryDSN;

        // Strongly recommended on web (adblockers often block tracing bundle)
        options.tracesSampleRate = kIsWeb ? 0.0 : 1.0;
        options.profilesSampleRate = kIsWeb ? 0.0 : 1.0;
      },
      appRunner: () => runApp(const App()),
    );
  } catch (e, st) {
    debugPrint('Sentry init failed: $e');
    debugPrintStack(stackTrace: st);
    runApp(const App());
  }
}

