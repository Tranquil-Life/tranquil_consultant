import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/core/utils/services/app_data_store.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController instance = Get.find();

  @override
  void onInit() {
    navigateTo();
    super.onInit();
  }

  navigateTo(){
    checkUserIsLogged();

  }

  void checkUserIsLogged() async{
    if(AppData.isSignedIn == true)
    {
      if(userDataStore.user['auth_token'] != null){

        await AuthController.instance.isUserAuthenticated();

      }else{
        await Future.delayed(const Duration(seconds: 3));
        Get.offAllNamed(Routes.ONBOARDING);
      }
    }else{
      await Future.delayed(const Duration(seconds: 3));

      Get.offAllNamed(Routes.ONBOARDING);
    }

  }

}