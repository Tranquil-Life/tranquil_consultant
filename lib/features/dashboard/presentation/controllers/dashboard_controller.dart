import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/helpers/timezone_converter.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/data/repos%20/location_repo.dart';
import 'package:tl_consultant/features/home/presentation/controllers/home_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

class DashboardController extends GetxController {
  
 RxInt currentIndex = 0.obs;

  var currentMeetingCount = 0.obs;
  var clientId = 0.obs;
  var clientName = "".obs;
  var clientDp = "".obs;
  var currentMeetingET = "".obs;
  var currentMeetingST = "".obs;
  var currentMeetingId = 0.obs;

  Future<void> onTap(int index) async {
    currentIndex.value = index;
  }

  checkLocation() async {
    var result = await getCurrLocation();
    double latitude = result['latitude'];
    double longitude = result['longitude'];
    List<Placemark> placemarks = result['placemarks'];
    String country = placemarks.first.country!;
    String state = placemarks.first.administrativeArea!;
    var location = "$country/$state";
    var continent = await ProfileController().getContinent(placemarks);
    print("CONTINE: $continent");
    var timeZoneIdentifier =
        TimeZoneUtil.getTzIdentifier(continent: continent, state: state);
    final timeZone = tz.getLocation(timeZoneIdentifier).currentTimeZone;
    var hourInMilliSecs = 3600000;
    var formattedTimeZone = timeZone.offset / hourInMilliSecs;

    print(location);
    print(userDataStore.user['location']);
    if (location != userDataStore.user['location']) {
      updateMyLocation(
          latitude, longitude, formattedTimeZone, location, timeZoneIdentifier);
    }
  }

  updateMyLocation(double latitude, double longitude, double timeZone,
      String location, String timeZoneIdentifier) async {
    debugPrint(
        "lat: $latitude\nlong: $longitude\ntz: $timeZone\nlocation: $location\ntzIdentifier: $timeZoneIdentifier");

    var either = await LocationRepoImpl().updateLocation(
        latitude: latitude,
        longitude: longitude,
        timeZone: timeZone,
        location: location,
        timeZoneIdentifier: timeZoneIdentifier);

    either.fold(
      (l) {
        print("IDENTIFIER: ${l.message}");

        CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: "UPDATE LOCATION: ${l.message!}",
          backgroundColor: ColorPalette.red,
        );
      },
      (r) {
        Map data = r['data'];
        print("IDENTIFIER: $data");
        userDataStore.user['timezone_identifier'] = data['timezone_identifier'];
      },
    );

    userDataStore.user = userDataStore.user;
    getMeetings();
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
    ProfileController.instance.restoreUser();

    checkLocation();

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
