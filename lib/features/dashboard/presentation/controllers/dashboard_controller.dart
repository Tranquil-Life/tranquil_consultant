import 'package:get/get.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/consultation/domain/entities/participant.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/consultation_controller.dart';
import 'package:tl_consultant/features/home/presentation/controllers/home_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';

class DashboardController extends GetxController{
  static DashboardController instance = Get.find();

  var currentIndex = 0.obs;

  var currentMeetingCount = 0.obs;
  var clientId = 0.obs;
  var clientName = "".obs;
  var clientDp = "".obs;
  var currentMeetingET = "".obs;
  var currentMeetingST = "".obs;
  var currentMeetingId = 0.obs;
  var authToken = "".obs;

  Future<void> onTap(int index) async{
    currentIndex.value = index;
  }

  clearData(){
    currentIndex.value = 0;
  }

  clearAllData(){
    AuthController.instance.clearData();
    HomeController.instance.clearData();
    ConsultationController.instance.clearData();
    NotesController.instance.clearData();
    clearData();
  }
}