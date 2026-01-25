import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/consultation/data/repos/consultation_repo.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class SlotController extends GetxController {
  static SlotController get instance => Get.find<SlotController>();

  ConsultationRepoImpl repo = ConsultationRepoImpl();

  var loading = false.obs;

  var now = DateTimeExtension.now;

  var timeSlots = <String>[].obs;
  RxList selectedDays = [].obs;

  // var apiSlots = [];

  void addToSlots(String time) => timeSlots.add(time);

  bool removeFromSlots(String time) => timeSlots.remove(time);

  // List<String> get listInUtc {
  //   final utcSlots = <String>[];
  //
  //   final timeZone = UserModel.fromJson(userDataStore.user).timezone;
  //   final match = RegExp(r'-?\d+').firstMatch(timeZone.toString());
  //   final offsetHours = int.tryParse(match?.group(0) ?? '0') ?? 0;
  //
  //   const anchor = "2000-01-01";
  //
  //   for (final element in timeSlots) {
  //     final localDateTime =
  //     DateFormat("yyyy-MM-dd HH:mm").parse("$anchor $element");
  //
  //     // INVERT SIGN HERE
  //     final utcDateTime =
  //     localDateTime.add(Duration(hours: -offsetHours));
  //
  //     utcSlots.add(DateFormat("HH:mm").format(utcDateTime));
  //   }
  //
  //   return utcSlots.toSet().toList();
  // }

  // void getSlotsInLocal() {
  //   timeSlots.clear(); //
  //
  //   for (var element in apiSlots) {
  //     final dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(
  //       "${DateTimeExtension.now.year}"
  //       "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
  //       "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} $element",
  //       true,
  //     );
  //
  //     var timeZone = UserModel.fromJson(userDataStore.user).timezone;
  //
  //     // extract number from "UTC-6", "GMT-6", etc.
  //     final match = RegExp(r'-?\d+').firstMatch(timeZone.toString());
  //     final offsetHours = int.tryParse(match?.group(0) ?? '0') ?? 0;
  //
  //     final dateLocal = dateTime.subtract(
  //       Duration(hours: offsetHours),
  //     );
  //
  //     timeSlots.add(
  //       "${dateLocal.hour.toString().padLeft(2, "0")}"
  //       ":${dateLocal.minute.toString().padLeft(2, "0")}",
  //     );
  //   }
  //
  //   // optional safety: de-dupe local list
  //   timeSlots.value = timeSlots.toSet().toList();
  //
  //   print("Local Slots: $timeSlots");
  // }

  Future saveSlots({List? availableDays}) async {
    var result =
        await repo.saveSlots(slots: timeSlots, availableDays: availableDays);

    if (result.isRight()) {
      print("Added Slots: $timeSlots");

      CustomSnackBar.successSnackBar(body: "Saved");
    } else {
      CustomSnackBar.errorSnackBar("Couldn't save slots");
    }
  }

  Future getAllSlots() async {
    loading.value = true;

    Either either = await ConsultationRepoImpl().getSlots();

    timeSlots.clear();

    either.fold((l) {
      loading.value = false;
    }, (r) {
      loading.value = false;

      if (r['days'] != null) {
        availableDays(r['days']);
      }

      timeSlots.value = List<String>.from(r['slots'] ?? []);
      // timeSlots.clear(); // so it doesn't keep previous state
      // if (apiSlots.isNotEmpty) getSlotsInLocal();

      print("Get Slots: $timeSlots");
    });
  }

  void availableDays(Map<String, dynamic> daysMap) {
    selectedDays.value = daysMap.keys
        .map((e) {
          if (daysMap[e] == true) return e.capitalizeFirst;
        })
        .toList()
        .where((element) => element != null)
        .toList();
  }

  void clearData() {
    timeSlots.clear();
    // apiSlots.clear();
    selectedDays.clear();
    loading.value = false;
  }
}
