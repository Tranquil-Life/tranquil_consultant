import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/consultation/data/models/meeting_model.dart';
import 'package:tl_consultant/features/consultation/data/repos/consultation_repo.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class ConsultationController extends GetxController {
  static ConsultationController instance = Get.find();
  final repo = ConsultationRepoImpl();

  //pagination vars
  var page = 1.obs;
  // There is next page or not
  var hasNextPage = true.obs;
  // Used to display loading indicators when _firstLoad function is running
  var isFirstLoadRunning = false.obs;
  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;
  var lastMessageId = 0.obs;
  // The controller for the ListView
  late ScrollController scrollController;
  var meetingsCount = 0.obs;
  DateTime? meetingDate;

  RxList<Meeting> meetings = RxList<Meeting>();

  var loading = false.obs;

  var now = DateTimeExtension.now;
  var timeSlots = [].obs;
  RxList selectedDays = [].obs;
  var apiSlots = [];

  addToSlots(String time) => instance.timeSlots.add(time);
  removeFromSlots(String time) => instance.timeSlots.remove(time);

  List get listInUtc {
    List utcSlots = [];
    for (var element in instance.timeSlots) {
      var newTime = DateTime.parse("${DateTimeExtension.now.year}"
              "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
              "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} $element")
          .toUtc();
      utcSlots.add("${newTime.hour.toString().padLeft(2, "0")}"
          ":${newTime.minute.toString().padLeft(2, "0")}");
    }
    return utcSlots;
  }

  getSlotsInLocal() {
    for (var element in apiSlots) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(
          "${DateTimeExtension.now.year}"
          "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
          "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} $element",
          true);
      var dateLocal = dateTime.toLocal();

      timeSlots.add("${dateLocal.hour.toString().padLeft(2, "0")}"
          ":${dateLocal.minute.toString().padLeft(2, "0")}");
    }
  }

  Future saveSlots({List? availableDays}) async {
    var result =
        await repo.saveSlots(slots: listInUtc, availableDays: availableDays);

    if (result.isRight()) {
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Success",
          message: "Saved",
          backgroundColor: ColorPalette.green);
    } else {
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: "Couldn't save slots",
          backgroundColor: ColorPalette.red);
    }
  }

  Future getAllSlots() async {
    var result = await ConsultationRepoImpl().getSlots();
    loading.value = true;

    if (result.isRight()) {
      loading.value = false;

      result.map((r) {
        apiSlots = r['slots'];
        availableDays(r['days']);

        getSlotsInLocal();
      });
    } else {
      loading.value = false;
      instance.timeSlots.clear();
    }
  }

  Future loadFirstMeetings() async {
    if (userDataStore.user['timezone_identifier'] == null) {
      print("null");
    } else {
      isFirstLoadRunning.value = true;

      var either = await ConsultationRepoImpl().getMeetings(page: page.value);

      either.fold(
          (l) => CustomSnackBar.showSnackBar(
                context: Get.context!,
                title: "Error",
                message: l.message.toString(),
                backgroundColor: ColorPalette.red,
              ), (r) async {
        var data = r;

        if (data['error'] == false && data['data'] != null) {
          meetings.clear(); // Clear existing meetings
          for (var element in data['data']) {
            Meeting meeting = await MeetingModel.fromJsonWithTimeZone(element);
            meetings.add(meeting);
          }

          if (meetings.isNotEmpty) {
            lastMessageId.value = meetings[meetings.length - 1].id;
          } else {
            isFirstLoadRunning.value = false;
          }
        }
      });

      update(); // Notify listeners that the meetings list has changed
      isFirstLoadRunning.value = false;
    }
  }

  Future loadMoreMeetings() async {
    if (hasNextPage.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.position.extentAfter < 300) {
      isLoadMoreRunning.value =
          true; // Display a progress indicator at the bottom
      page.value += 1; // Increase _page by 1

      var either = await ConsultationRepoImpl().getMeetings(page: page.value);

      either.fold(
          (l) => CustomSnackBar.showSnackBar(
                context: Get.context!,
                title: "Error",
                message: l.message.toString(),
                backgroundColor: ColorPalette.red,
              ), (r) async {
        var data = r;

        List<Meeting> fetchedMeetings = [];

        for (var element in data['data']) {
          Meeting meeting = await MeetingModel.fromJsonWithTimeZone(element);
          fetchedMeetings.add(meeting);
        }
      });

      update();

      isLoadMoreRunning.value = false;
    }
  }

  availableDays(Map<String, dynamic> daysMap) {
    selectedDays.value = daysMap.keys
        .map((e) {
          if (daysMap[e] == true) return e.capitalizeFirst;
        })
        .toList()
        .where((element) => element != null)
        .toList();
  }

  void clearData() {}
}
