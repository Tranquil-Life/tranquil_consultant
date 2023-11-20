import 'package:get/get.dart';
import 'package:tl_consultant/app/data/store.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/features/auth/data/repos/auth_repo.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class SettingsController extends GetxController{
  static SettingsController instance = SettingsController();

  AuthRepoImpl authRepoImpl = AuthRepoImpl();

  UserDataStore userDataStore = UserDataStore();

  signOut() async{
    var result = await authRepoImpl.signOut();
    if(result.isRight()){
      await getStore.clearAllData();
      //disconnectLaravel();

      Get.offAllNamed(Routes.SIGN_IN);
    }
  }

  disconnectLaravel(){
    //LaravelEcho.instance.disconnect();
  }
}