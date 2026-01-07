import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/consultation/data/repos/consultation_repo.dart';

class SlotController extends GetxController {
  static SlotController get instance => Get.find<SlotController>();

  ConsultationRepoImpl repo = ConsultationRepoImpl();

  var loading = false.obs;

  var now = DateTimeExtension.now;

  var timeSlots = [].obs;
  RxList selectedDays = [].obs;
  var apiSlots = [];

  void addToSlots(String time) => timeSlots.add(time);
  bool removeFromSlots(String time) => timeSlots.remove(time);

  List get listInUtc {
    List utcSlots = [];
    for (var element in timeSlots) {
      var newTime = DateTime.parse("${now.year}"
              "-${now.month.toString().padLeft(2, "0")}"
              "-${now.day.toString().padLeft(2, "0")} $element")
          .toUtc();
      utcSlots.add("${newTime.hour.toString().padLeft(2, "0")}"
          ":${newTime.minute.toString().padLeft(2, "0")}");
    }
    return utcSlots;
  }

  void getSlotsInLocal() {
    timeSlots.clear(); // ✅ important: replace, don’t append

    for (var element in apiSlots) {
      final dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(
        "${DateTimeExtension.now.year}"
            "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
            "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} $element",
        true,
      );

      final dateLocal = dateTime.toLocal();

      timeSlots.add(
        "${dateLocal.hour.toString().padLeft(2, "0")}"
            ":${dateLocal.minute.toString().padLeft(2, "0")}",
      );
    }

    // optional safety: de-dupe local list
    timeSlots.value = timeSlots.toSet().toList();
  }


  Future saveSlots({List? availableDays}) async {
    var result =
        await repo.saveSlots(slots: listInUtc, availableDays: availableDays);

    if (result.isRight()) {
      CustomSnackBar.successSnackBar(
          body: "Saved");
    } else {
      CustomSnackBar.errorSnackBar(
          "Couldn't save slots");
    }
  }

  Future getAllSlots() async {
    loading.value = true;

    Either result = await ConsultationRepoImpl().getSlots();

    result.fold((l) {
      loading.value = false;
      timeSlots.clear();

      // if(l.message == "No Slots"){
      // CustomSnackBar.showSnackBar(context: Get.context!, title: "Error", message: message, backgroundColor: backgroundColor)

      // }

      print("Error: ${l.message}");
    }, (r) {
      loading.value = false;

      if(r['days'] != null){
        availableDays(r['days']);
      }

      apiSlots = r['slots'] ?? [];
      timeSlots.clear(); // so it doesn't keep previous state
      if (apiSlots.isNotEmpty) getSlotsInLocal();

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
    apiSlots.clear();
    selectedDays.clear();
    loading.value = false;
  }
}
