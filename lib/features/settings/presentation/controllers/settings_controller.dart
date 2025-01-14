import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/data/store.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/transactions_controller.dart';

class SettingsController extends GetxController {
  static SettingsController instance = SettingsController();

  AuthRepoImpl authRepoImpl = AuthRepoImpl();

  UserDataStore userDataStore = UserDataStore();

  signOut() async {
    Either either = await authRepoImpl.signOut();
    either.fold((l) {
      DashboardController().clearAllData();

      Get.offAllNamed(Routes.SIGN_IN);
    }, (r) async {
      await getStore.clearAllData();

      Get.offAllNamed(Routes.SIGN_IN);
    });
  }
}
