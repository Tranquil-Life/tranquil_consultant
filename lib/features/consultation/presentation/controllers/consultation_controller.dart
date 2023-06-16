import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/consultation/data/models/meeting_model.dart';
import 'package:tl_consultant/features/consultation/data/repos/consultation_repo.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/core/utils/helpers/day_section_option.dart';

class ConsultationController extends GetxController{
  static ConsultationController instance = Get.find();

  final meetingsStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get meetingsStream => meetingsStreamController.stream;

  var now = DateTime.now();

  var call = 0.obs;
  Timer? callTimer;

  var meetingsCount = 0.obs;

  DateTime? meetingDate;
  var timeSlots = [].obs;
  var loading = false.obs;

  var selectedTime = "".obs;
  var selectedDate = "".obs;

  int daySectionStatus(DaySectionOption? initial, DaySectionOption? current, int selectedIndex) {
    if(initial == current){
      return selectedIndex;
    }else{
      return -1;
    }
  }

  // selectedSlot(String? time, DaySectionOption? initial, DaySectionOption? current){
  //   if(initial == current){
  //     return time.toString();
  //   }else{
  //     return null;
  //   }
  // }

  Future getAllSlots() async {
    timeSlots.clear();
    loading.value = true;

    var either = await ConsultationRepoImpl().getSlots();
    if(either.isRight()){
      loading.value = false;
      either.map((r){
        timeSlots.value = r;
      });

    }
    else{
      either.leftMap((l){
        loading.value = false;

        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Error",
            message: l.message.toString(),
            backgroundColor: ColorPalette.green);
      });
    }
  }

  Future getMeetings() async{
    Timer.periodic(const Duration(seconds: 1), (timer) async{
      var result = await ConsultationRepoImpl().getMeetings();

      callTimer = timer;
      call.value++;

      if(result.isRight()){
        callTimer?.cancel();
        timer.cancel();

        List<Meeting> meetings = [];

        result.map((r){
          for (var element in r) {
            Meeting meeting = MeetingModel.fromJson(element);
            meetings.add(meeting);

            if(meeting.endAt.isAfter(now)
                && (meeting.startAt.isBefore(now) || meeting.startAt == now))
            {
              DashboardController.instance.ongoingMeetingCount.value = 1;

              DashboardController.instance.ongoingMeetingId.value = meeting.id;
              DashboardController.instance.clientDp.value = meeting.client.avatarUrl;
              DashboardController.instance.clientDp.value = meeting.client.firstName;
              DashboardController.instance.ongoingMeetingST.value = meeting.startAt.formatDate;
              DashboardController.instance.ongoingMeetingET.value = meeting.endAt.formatDate;

              print("ONGOING: ${DashboardController.instance.ongoingMeetingId.value}");

              print("CLIENT_NAME: ${DashboardController.instance.clientName.value}");
            }
          }
        });

        Map<String, dynamic> values = {
          "meetings": meetings,
          "num_of_meetings": meetings.length,
        };

        meetingsCount.value = meetings.length;

        if (!meetingsStreamController.isClosed) meetingsStreamController.sink.add(values);

        debugPrint(meetings.isNotEmpty ? meetings[0].endAt.toString() : null);
      }
      else{
        result.leftMap((l){
          print("MEETINGS: calls: ${call.value}");
          if(call.value>=10) {
            callTimer?.cancel();
            timer.cancel();

            // CustomSnackBar.showSnackBar(
            //     context: Get.context!,
            //     title: "Error",
            //     message: l.message!,
            //     backgroundColor: ColorPalette.red
            // );
          }}
        );
      }
    });
  }


  void clearData() {
    //...
  }

}