import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/main.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final storage = GetStorage();
  AuthRepoImpl authRepo = AuthRepoImpl();
  User? client;

  RxBool notLoggedIn = true.obs;

  bool get isUpdatePasswordRoute {
    if (!kIsWeb) return false;
    return Uri.base.fragment.startsWith('/create-password');
  }

  Future<bool> checkOnboardingStatus() async {
    final userOnboarded = storage.read("onboarded");
    return userOnboarded == true;
  }

  void saveOnboardedStatus() async {
    await storage.write("onboarded", true);
  }

  Future checkAuthStatus() async {
    if (isUpdatePasswordRoute) {
      return;
    }

    Either either = await authRepo.isAuthenticated();

    either.fold((l) async {
      notLoggedIn.value = true;

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.DASHBOARD,
            (_) => false,
      );
    }, (r) async {
      notLoggedIn.value = false;

      userDataStore.user['email_verified_at'] =
      r['data']['email_verified_at'];

      if (kIsWeb) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.DASHBOARD,
              (_) => false,
        );
      } else {
        Get.offAllNamed(Routes.DASHBOARD);
      }
    });
  }
}