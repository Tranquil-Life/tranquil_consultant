import 'package:get/get.dart';
import 'package:tl_consultant/core/utils/services/API/network/controllers/network_controller.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/consultation_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:tl_consultant/features/settings/presentation/controllers/settings_controller.dart';

class AllControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OnBoardingController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => ActivityController());
    Get.lazyPut(() => NotesController());
    Get.lazyPut(() => SettingsController());
    Get.lazyPut(() => NotesController());
    Get.lazyPut(() => ConsultationController());
    Get.lazyPut(() => NetworkController());
  }

}