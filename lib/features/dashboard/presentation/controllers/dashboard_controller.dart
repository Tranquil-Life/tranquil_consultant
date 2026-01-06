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
import 'package:tl_consultant/main.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find<DashboardController>();

  final LocationRepoImpl locationRepo = LocationRepoImpl();

  static const int locationUpdateIntervalMs = 24 * 60 * 60 * 1000; // 24 hours

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
      print("update location:  $r");
    });
  }

  Future<Map<String, String?>> reverseGeocodeViaBackend({
    required double lat,
    required double lng,
  }) async {
    final result = <String, String?>{};

    final Either either =
    await locationRepo.reverseGeocode(latitude: lat, longitude: lng);

    either.fold(
          (l) => print("Reverse geocode: error: ${l.message ?? ''}"),
          (r) {
        print("reverse geocode: right: $r");

        // r is a Map, not Response
        final Map<String, dynamic> map = Map<String, dynamic>.from(r);

        // your API might return {data: {...}} or {...} directly
        final inner = (map['data'] is Map)
            ? Map<String, dynamic>.from(map['data'])
            : map;

        result['country'] = inner['country']?.toString();
        result['state'] = inner['state']?.toString();
      },
    );

    return result;
  }

  String _clean(String? s) => (s ?? '').trim();

  String normalizeCountry(String c) {
    final x = c.trim();
    final lower = x.toLowerCase();
    if (lower == 'usa' || lower == 'us' || lower.contains('united states')) return 'United States';
    if (lower == 'uk' || lower == 'gb' || lower.contains('united kingdom')) return 'United Kingdom';
    return x;
  }

  Future<void> getMyLocationInfo() async {
    final result = await getCurrLocation();
    if (result["error"] == true) return;

    final lat = result['latitude'] as double;
    final lng = result['longitude'] as double;

    final timeZoneHours = DateTime.now().timeZoneOffset.inMinutes / 60.0;

    String timeZoneIdentifier = "";
    try {
      timeZoneIdentifier = await FlutterNativeTimezone.getLocalTimezone();
    } catch (_) {}

    String locationToSend = "";

    try {
      //Using backend reverse coding
      final geo = await reverseGeocodeViaBackend(lat: lat, lng: lng);

      final c = normalizeCountry(_clean(geo['country']?.toString()));
      final s = _clean(geo['state']?.toString());

      country.value = c;
      state.value = s;

      locationToSend = [c, s].where((x) => x.isNotEmpty).join('/');

      if (locationToSend.isEmpty) {
        locationToSend = "$lat, $lng";
      }
    } catch (e) {
      // Fallback: use placemark if backend/network fails
      //TODO: Display dialog for countries and states


      CustomSnackBar.errorSnackBar("Reverse coding failed: $e");
    }

    await updateLocation(
      latitude: lat,
      longitude: lng,
      timeZone: timeZoneHours,
      location: locationToSend,
      timeZoneIdentifier: timeZoneIdentifier,
    );

    print("dashboard update: country: ${country.value}\nstate: ${state.value}\nlocationToSend: $locationToSend");
  }

  int? _readInt(String key) {
    final v = storage.read(key);
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }


  Future<void> getMyLocationInfoCached() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTs = _readInt(Keys.lastLocationUpdateKey);

    print("old last timestamp: $lastTs");

    // If we have a timestamp and it's still within 24h, skip
    if (lastTs != null && (now - lastTs) < locationUpdateIntervalMs) {
      debugPrint('Location update skipped (cached)');
      return;
    }

    debugPrint('Running location update');

    try {
      await getMyLocationInfo(); // Update location

      await storage.write(Keys.lastLocationUpdateKey, now); // ✅ await write
      await storage.save(); // ✅ force flush (important on web)

      final savedTs = _readInt(Keys.lastLocationUpdateKey);
      print("new last timestamp: $savedTs");
    } catch (e, s) {
      debugPrint('Location update failed: $e');
      debugPrintStack(stackTrace: s);
    }

  }

  Future<void> refreshLocationNow() async {
    await storage.remove(Keys.lastLocationUpdateKey); // ✅ await remove
    await storage.save(); // ✅ flush removal
    await getMyLocationInfoCached();
  }

  void clearData() {
    currentIndex.value = 0;

    currentMeetingCount.value = 0;
    currentMeetingId.value = 1;
    // clientId.value = 0;
    // clientName.value = "";
    // clientDp.value = "";
    // currentMeetingET.value = "";
    // currentMeetingST.value = "";

    country.value = '';
    city.value = '';
    timezone.value = '';
  }


  void clearAllData() {
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

  void updateIndex(int index) {
    currentIndex.value = index;
  }

  bool isSelected(int index) {
    return currentIndex.value == index;
  }
}
