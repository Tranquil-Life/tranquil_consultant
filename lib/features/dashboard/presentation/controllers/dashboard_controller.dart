import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/helpers/timezone_converter.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/home/presentation/controllers/home_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/qualification.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

class DashboardController extends GetxController {
  static DashboardController instance = Get.find();

  RxInt currentIndex = 0.obs;

  var currentMeetingCount = 0.obs;
  var clientId = 0.obs;
  var clientName = "".obs;
  var clientDp = "".obs;
  var currentMeetingET = "".obs;
  var currentMeetingST = "".obs;
  var currentMeetingId = 0.obs;

  var country = "".obs;
  var city = "".obs;
  var timezone = "".obs;

  Future<void> onTap(int index) async {
    currentIndex.value = index;
  }

  getMyLocationInfo() async {
    var result = await getCurrLocation();
    List<Placemark> placemarks = result['placemarks'];
    String currCountry = placemarks.first.country!;
    String state = placemarks.first.administrativeArea!;
    int timezoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    var hourInMilliSecs = 3600000;
    var formattedTimeZone = timezoneOffset / hourInMilliSecs;

    country.value = currCountry;
    city.value = state;
    timezone.value = "$formattedTimeZone";

  }

  getMeetings() async {
    await MeetingsController().loadFirstMeetings();

    for (var meeting in MeetingsController.instance.meetings) {
      if (meeting.endAt.isAfter(DateTimeExtension.now) &&
          (meeting.startAt.isBefore(DateTimeExtension.now) ||
              meeting.startAt == DateTimeExtension.now)) {
        currentMeetingCount.value = 1;
        currentMeetingId.value = meeting.id;
        clientId.value = meeting.client.id;
        clientDp.value = meeting.client.avatarUrl;
        clientName.value = meeting.client.firstName;
        currentMeetingST.value = meeting.startAt.formatDate;
        currentMeetingET.value = meeting.endAt.formatDate;
      }
    }
  }

  @override
  void onInit() {

    // ProfileController.instance.restoreUser();

    getMyLocationInfo();

    super.onInit();
  }


  clearData() {
    currentIndex.value = 0;
    currentMeetingCount.value = 0;
    var clientId = 0;
    var clientName = "";
    var clientDp = "";
    var currentMeetingET = "";
    var currentMeetingST = "";
    var currentMeetingId = 1;
  }

  clearAllData() {
    AuthController.instance.clearData();
    HomeController.instance.clearData();
    MeetingsController.instance.clearData();
    MeetingsController.instance.clearData();
    NotesController.instance.clearData();
    clearData();
  }
}
