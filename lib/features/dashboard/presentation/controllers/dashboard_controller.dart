import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/timezone_converter.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/activity/presentation/controllers/activity_controller.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/chat/presentation/screens/chat_screen.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/meetings_controller.dart';
import 'package:tl_consultant/features/dashboard/data/repos/location_repo.dart';
import 'package:tl_consultant/features/growth_kit/presentation/screens/growth_kit_page.dart';
import 'package:tl_consultant/features/home/presentation/controllers/home_controller.dart';
import 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';
import 'package:tl_consultant/features/journal/presentation/screens/journal_tab.dart';
import 'package:tl_consultant/features/media/presentation/controllers/video_recording_controller.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/qualification.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/transactions_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/screens/wallet_tab.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find<DashboardController>();

  final LocationRepoImpl locationRepo = LocationRepoImpl();

  RxInt currentIndex = 0.obs;
  final List<Widget> pages = [
    HomeTab(),
    JournalTab(),
    WalletTab(),
    GrowthKitPage()
  ];

  final List<Widget> largePages = [
    HomeTab(),
    JournalTab(),
    ChatScreen(),
    WalletTab(),
    GrowthKitPage()
  ];

  var currentMeetingCount = 0.obs;
  var clientId = 0.obs;
  var clientName = "".obs;
  var clientDp = "".obs;
  var currentMeetingET = "".obs;
  var currentMeetingST = "".obs;
  var currentMeetingId = 0.obs;

  var country = "".obs;
  var state = "".obs;
  var city = "".obs;
  var street = "".obs;
  var neighborhood = "".obs;
  var county = "".obs;
  var timezone = "".obs;

  Future<void> onTap(int index) async {
    currentIndex.value = index;
  }

  Future updateLocation(
      {required double latitude,
      required double longitude,
      required double timeZone,
      required String location,
      required String timeZoneIdentifier}) async {
    Either either = await locationRepo.updateLocation(
        latitude: latitude,
        longitude: longitude,
        timeZone: timeZone,
        location: location,
        timeZoneIdentifier: timeZoneIdentifier);

    either.fold((l) {
      print("update location: error: ${l.message!}");
    }, (r) {
      // print("update location:  $r");
    });
  }

  //TODO: REMEMBER TO UNCOMMENT
  Future getMyLocationInfo() async {
    final result = await getCurrLocation();

    if (result["error"] != null) {
      // handle / show error
      return;
    }

    final List<Placemark> placemarks =
        (result['placemarks'] as List<Placemark>?) ?? const [];

    final Placemark? p = placemarks.isNotEmpty ? placemarks.first : null;

    // Use empty string fallback instead of crashing
    country.value = p?.country ?? "";
    city.value = p?.locality ?? "";
    neighborhood.value = p?.subLocality ?? "";
    state.value = p?.administrativeArea ?? "";
    county.value = p?.subAdministrativeArea ?? "";

    final streetPart = [
      p?.street,
      p?.name,
    ].whereType<String>().where((s) => s.trim().isNotEmpty).join(", ");

    street.value = streetPart;

    // timezone offset (this works on web too)
    final timezoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    const hourInMilliSecs = 3600000;
    final formattedTimeZone = timezoneOffset / hourInMilliSecs;
    timezone.value = "$formattedTimeZone";

    // FlutterNativeTimezone is NOT reliable on web; guard it
    String timeZoneIdentifier = "";
    try {
      timeZoneIdentifier = await FlutterNativeTimezone.getLocalTimezone();
    } catch (_) {
      timeZoneIdentifier = ""; // or "UTC"
    }

    // Build a best-effort location string
    final parts = <String>[
      street.value,
      neighborhood.value,
      city.value,
      county.value,
      state.value,
      country.value,
    ].where((s) => s.trim().isNotEmpty).toList();

    final locationString = parts.isNotEmpty
        ? parts.join(", ")
        : "${result['latitude']}, ${result['longitude']}";

    await updateLocation(
      latitude: result['latitude'],
      longitude: result['longitude'],
      timeZone: double.tryParse(timezone.value) ?? 0.0,
      location: locationString,
      timeZoneIdentifier: timeZoneIdentifier,
    );
  }

  Future<void> getMeetings() async {
    await MeetingsController().loadFirstMeetings();

    for (var meeting in MeetingsController.instance.meetings) {
      if (meeting.endAt.isAfter(DateTimeExtension.now) &&
          (meeting.startAt.isBefore(DateTimeExtension.now) ||
              meeting.startAt == DateTimeExtension.now)) {
        currentMeetingCount.value = 1;
        currentMeetingId.value = meeting.id;
        clientId.value = meeting.client.id!;
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

    //TODO: REMEMBER TO UNCOMMENT
    getMyLocationInfo();

    super.onInit();
  }

  clearData() {
    currentIndex.value = 0;

    currentMeetingCount.value = 0;
    clientId.value = 0;
    clientName.value = "";
    clientDp.value = "";
    currentMeetingET.value = "";
    currentMeetingST.value = "";
    currentMeetingId.value = 1;

    country.value = '';
    city.value = '';
    timezone.value = '';
  }

  clearAllData() {
    AuthController().clearData();
    HomeController().clearData();
    MeetingsController().clearData();
    NotesController().clearData();
    ProfileController().clearData();
    ActivityController().clearData();
    EarningsController().clearData();
    TransactionsController().clearData();
    VideoRecordingController().clearData();
    NotesController().clearData();
    clearData();
  }

  updateIndex(int index) {
    currentIndex.value = index;
  }

  bool isSelected(int index) {
    return currentIndex.value == index;
  }
}
