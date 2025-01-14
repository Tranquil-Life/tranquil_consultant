import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/features/consultation/data/models/meeting_model.dart';
import 'package:tl_consultant/features/consultation/data/repos/consultation_repo.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/slot_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class MeetingsController extends GetxController {
  static MeetingsController instance = Get.find();

  SlotController slotController = Get.put(SlotController());

  ConsultationRepoImpl repo = ConsultationRepoImpl();

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
  var loading = false.obs;

  RxList<Meeting> meetings = RxList<Meeting>();

  Future loadFirstMeetings() async {
    if (userDataStore.user['timezone_identifier'] == null) {
      print("null");
    } else {
      isFirstLoadRunning.value = true;

      var either = await ConsultationRepoImpl().getMeetings(page: page.value);

      either.fold(
          (l) {
            print("MEETINGS: Error message: ${l.message}");

            return CustomSnackBar.showSnackBar(
              context: Get.context!,
              title: "Error",
              message: l.message.toString(),
              backgroundColor: ColorPalette.red,
            );
          }, (r) async {
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

  // navigateToDashboard() {
  //   Get.back();
  //   Get.back();
  //   Get.back();
  //   Get.back();
  //   Get.back();
  // }

  clearData() {
    meetingsCount.value = 0;
    loading.value = false;
    meetings.clear();
  }
}
