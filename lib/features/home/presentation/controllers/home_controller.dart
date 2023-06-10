import 'package:get/get.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class HomeController extends GetxController{
  static HomeController instance = Get.find();

  RxString alertMessage = "".obs;

  UserDataStore userDataStore = UserDataStore();

  var selectedMood = "".obs;

  void clearData() {
    alertMessage.value ="";
  }
}