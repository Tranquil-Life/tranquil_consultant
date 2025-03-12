import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/core/utils/services/app_data_store.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class OnboardingController extends GetxController {
  static OnboardingController instance = Get.find();

  final storage = GetStorage();
  AuthRepoImpl authRepo = AuthRepoImpl();
  User? client;

  Future<bool> checkOnboardingStatus() async {
    final userOnboarded = storage.read("onboarded");
    if (userOnboarded == null) {
      return false;
    } else {
      return userOnboarded!;
    }
  }

  void saveOnboardedStatus() async {
    await storage.write("onboarded", true);
  }

  Future checkAuthStatus() async {
    Either either = await authRepo.isAuthenticated();
    either.fold((l) async {
      Get.offAllNamed(Routes.SIGN_IN);
    }, (r) async {
      userDataStore.user['email_verified_at'] = r['data']['email_verified_at'];

      Get.offAllNamed(Routes.DASHBOARD);
    });
  }
}
