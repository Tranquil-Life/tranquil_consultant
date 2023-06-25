import 'package:get/get.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/consultation_controller.dart';
import 'package:tl_consultant/features/home/presentation/controllers/home_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';

class DashboardController extends GetxController{
  static DashboardController instance = Get.find();

  RxInt currentIndex = 0.obs;

  RxInt ongoingMeetingCount = 0.obs;
  var clientName = "".obs;
  var clientDp = "".obs;
  var ongoingMeetingET = "".obs;
  var ongoingMeetingST = "".obs;
  var ongoingMeetingId = 1.obs;

  var authToken = "".obs;
  var firstName = "".obs;
  var lastName = "".obs;

  Future<void> onTap(int index) async{
    currentIndex.value = index;
  }

  clearData(){
    currentIndex.value = 0;
    authToken.value = "";
  }

  clearAllData(){
    AuthController.instance.clearData();
    HomeController.instance.clearData();
    NotesController.instance.clearData();
    clearData();
  }
}