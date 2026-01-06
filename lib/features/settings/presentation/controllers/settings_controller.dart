import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/data/store.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/auth/data/repos/reg_data_store.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  AuthRepoImpl authRepoImpl = AuthRepoImpl();

  UserDataStore userDataStore = UserDataStore();

  Future<void> signOut() async {
    Either either = await authRepoImpl.signOut();
    either.fold((l) async{
      DashboardController().clearAllData();
      await getStore.clearAllData();

      Get.offAllNamed(Routes.SIGN_IN);
    }, (r) async {
      DashboardController().clearAllData();
      await getStore.clearAllData();
      //TODO: Test the above by signing out. => storage.erase();
      Get.offAllNamed(Routes.SIGN_IN);
    });
  }
}
