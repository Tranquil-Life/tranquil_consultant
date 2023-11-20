import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/core/utils/services/app_data_store.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

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
    if(userDataStore.user.isEmpty){
      AppData.isSignedIn == false;
      Future.delayed(Duration.zero, () {
        Get.offAllNamed(Routes.ONBOARDING);
      });
    }else{
      User client = UserModel.fromJson(userDataStore.user);

      if(AppData.isSignedIn == true)
      {
        if(client.authToken!.isNotEmpty){
          Future.delayed(Duration.zero, () {
            Get.offAllNamed(Routes.DASHBOARD);
          });
        }else{
          await Future.delayed(const Duration(seconds: 2));

          Get.offAllNamed(Routes.ONBOARDING);
        }
      }else{
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(Routes.ONBOARDING);
      }
    }


  }


}