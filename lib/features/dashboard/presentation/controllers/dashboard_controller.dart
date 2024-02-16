import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/helpers/timezone_converter.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/consultation_controller.dart';
import 'package:tl_consultant/features/dashboard/data/repos%20/location_repo.dart';
import 'package:tl_consultant/features/home/presentation/controllers/home_controller.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  var currentMeetingCount = 1.obs;
  var clientId = 0.obs;
  var clientName = "".obs;
  var clientDp = "".obs;
  var currentMeetingET = "".obs;
  var currentMeetingST = "".obs;
  var currentMeetingId = 0.obs;
  var authToken = "".obs;

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
    final timeZone = tz
        .getLocation(
            TimeZoneUtil.getTzIdentifier(continent: continent, state: state))
        .currentTimeZone;
    var hourInMilliSecs = 3600000;
    var formattedTimeZone = timeZone.offset / hourInMilliSecs;
    var timeZoneIdentifier =
        TimeZoneUtil.getTzIdentifier(continent: continent, state: state);

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
        CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: l.message!,
          backgroundColor: ColorPalette.red,
        );
      },
      (r) {
        print("UPDATE LOCATION RESPONSE: $r");
      },
    );
  }

  @override
  void onInit() {
    ProfileController.instance.restoreUser();

    checkLocation();

    super.onInit();
  }

  clearData() {
    currentIndex.value = 0;
  }

  clearAllData() {
    AuthController.instance.clearData();
    HomeController.instance.clearData();
    ConsultationController.instance.clearData();
    NotesController.instance.clearData();
    clearData();
  }
}
