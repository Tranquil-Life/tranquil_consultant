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
import 'package:tl_consultant/features/auth/presentation/controllers/verification_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/message_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/video_call_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/growth_kit/presentation/controllers/growth_kit_controller.dart';
import 'package:tl_consultant/features/home/presentation/controllers/event_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/media_controller.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

import 'core/constants/constants.dart';
import 'core/global/custom_snackbar.dart';
import 'features/activity/presentation/controllers/activity_controller.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/chat/presentation/controllers/upload_controller.dart';
import 'features/consultation/presentation/controllers/meetings_controller.dart';
import 'features/consultation/presentation/controllers/slot_controller.dart';
import 'features/home/presentation/controllers/home_controller.dart';
import 'features/journal/presentation/controllers/notes_controller.dart';
import 'features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'features/settings/presentation/controllers/settings_controller.dart';
import 'features/wallet/presentation/controllers/earnings_controller.dart';
import 'features/wallet/presentation/controllers/transactions_controller.dart';

late List<CameraDescription> cameras = [];
PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
GetStorage storage = GetStorage();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🔕 Background message: $message");
  debugPrint("🔕 Background message title: ${message.notification?.title}");
  debugPrint("🔕 Background message body: ${message.notification?.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('Firebase initialized');
  } catch (e) {
    print('Firebase init failed: $e');
  }

  await GetStorage.init();

  if (!kIsWeb) {
    tz.initializeTimeZones();

    // Background handler (mobile only)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Listen for messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');

    final title = message.notification?.title ?? 'Tranquil Life';
    final body = message.notification?.body ?? '';

    CustomSnackBar.neutralSnackBar(
      title: title,
      body,
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('Notification clicked: ${message.notification?.title}');
  });


  // Register before running the app
  Get.put<ProfileController>(ProfileController());
  Get.put<OnboardingController>(OnboardingController());
  Get.put<AuthController>(AuthController());
  Get.put<VerificationController>(VerificationController());
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
  Get.put<MediaController>(MediaController());
  Get.put<NetworkController>(NetworkController());
  Get.put<GrowthKitController>(GrowthKitController());

  if (!kIsWeb) {
    try {
      cameras = await availableCameras().timeout(const Duration(seconds: 5));
    } catch (_) {
      cameras = [];
    }
  } else {
    cameras = [];
  }

  // await SentryFlutter.init(
  //       (options) {
  //     options.dsn = OtherConstants.sentryDSN;
  //     options.tracesSampleRate = 1.0;
  //     options.profilesSampleRate = 1.0;
  //   },
  // );

  runApp(const App());
}
