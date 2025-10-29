import 'package:get/get.dart';
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/agora_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/recording_controller.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/upload_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/slot_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/growth_kit/presentation/controllers/growth_kit_controller.dart';
import 'package:tl_consultant/features/home/presentation/controllers/home_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:tl_consultant/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/transactions_controller.dart';

class AllControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => ActivityController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => EarningsController());
    Get.lazyPut(() => TransactionsController());
    Get.lazyPut(() => NotesController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => SettingsController());
    Get.lazyPut(() => NotesController());
    Get.lazyPut(() => MeetingsController());
    Get.lazyPut(() => SlotController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => AgoraController());
    Get.lazyPut(() => RecordingController());
    Get.lazyPut(() => UploadController());
    Get.lazyPut(() => VideoRecordingController());
    Get.lazyPut(() => NetworkController());
    Get.lazyPut(() => GrowthKitController());
  }
}
