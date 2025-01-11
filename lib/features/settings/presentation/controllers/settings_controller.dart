import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/data/store.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class SettingsController extends GetxController {
  static SettingsController instance = SettingsController();

  AuthRepoImpl authRepoImpl = AuthRepoImpl();

  UserDataStore userDataStore = UserDataStore();

  signOut() async {
    Either either = await authRepoImpl.signOut();
    either.fold((l) {
      Get.offAllNamed(Routes.SIGN_IN);
    }, (r) async {
      await getStore.clearAllData();

      Get.offAllNamed(Routes.SIGN_IN);
    });
  }
}
