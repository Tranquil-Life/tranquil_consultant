import 'package:get/get.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/onboarding/presentation/controllers/onboarding_controller.dart';

class AllControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OnBoardingController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => DashboardController());
  }

}