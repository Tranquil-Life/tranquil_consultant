import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/features/consultation/data/models/meeting_model.dart';
import 'package:tl_consultant/features/consultation/data/models/rating_model.dart';
import 'package:tl_consultant/features/consultation/data/repos/consultation_repo.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';
import 'package:tl_consultant/features/consultation/presentation/controllers/slot_controller.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class MeetingsController extends GetxController {
  static MeetingsController get instance => Get.find();

  // SlotController slotController = Get.put(SlotController());

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
  Rxn<Meeting> currentMeeting = Rxn<Meeting>();

  Future loadFirstMeetings() async {
    if (userDataStore.user['timezone_identifier'] == null) {
      print("null");
    } else {
      isFirstLoadRunning.value = true;

      Either either = await repo.getMeetings(page: page.value);

      either.fold((l) {
        if(!l.message!.contains('unauthenticated')){
          print("Load first meetings: error: ${l.message}");

          return CustomSnackBar.errorSnackBar(
            l.message.toString());
        }

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
          (l) {
            if(!l.message!.contains('unauthenticated')){
              print("Load more meetings: error: ${l.message}");

              return CustomSnackBar.errorSnackBar(
                l.message.toString());
            }
          }, (r) async {
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

  Future rateMeeting(
      {int? meetingId,
      int? participantId,
      int? ratingByConsultant,
      String? commentByConsultant,
      int? overallMeetingRatingByConsultant}) async {
    Either either = await repo.rateMeeting(
        rating: RatingModel(
            meetingId: meetingId!,
            participantId: participantId!,
            ratingByConsultant: ratingByConsultant!,
            commentByConsultant: commentByConsultant,
            overallMeetingRatingByConsultant:
                overallMeetingRatingByConsultant));

    either.fold((l){
      print(l.message!);
      CustomSnackBar.errorSnackBar(l.message!);
    }, (r) async{
      print("rate meeting: $r");

      await loadFirstMeetings();

    });
  }

  // navigateToDashboard() {
  //   Get.back();
  //   Get.back();
  //   Get.back();
  //   Get.back();
  //   Get.back();
  // }

  void clearData() {
    meetingsCount.value = 0;
    loading.value = false;
    meetings.clear();
  }

  Future<void> startMeeting() async {
    loading.value = true;

    Either either = await repo.startMeeting(meetingId: currentMeeting.value!.id, userType: consultant);

    either.fold((l) {
      loading.value = false;
      debugPrint("Start meeting: error: ${l.message}");

      return CustomSnackBar.errorSnackBar(
        l.message.toString()
      );
    }, (r) {
      loading.value = false;
      debugPrint("Start meeting: ${r['data']}");
    });
  }
}
