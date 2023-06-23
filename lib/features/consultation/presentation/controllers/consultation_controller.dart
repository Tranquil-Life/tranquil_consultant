import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/consultation/data/models/meeting_model.dart';
import 'package:tl_consultant/features/consultation/data/repos/consultation_repo.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';

class ConsultationController extends GetxController{
  static ConsultationController instance = Get.find();
  final repo = ConsultationRepoImpl();

  final meetingsStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get meetingsStream => meetingsStreamController.stream;

  var call = 0.obs;
  Timer? callTimer;

  var meetingsCount = 0.obs;

  DateTime? meetingDate;
  var timeSlots = [].obs;
  var loading = false.obs;

  var apiSlots = [];

  addToSlots(String time)=>instance.timeSlots.add(time);
  removeFromSlots(String time)=>instance.timeSlots.remove(time);

  List get listInUtc {
    List utcSlots = [];
    for (var element in instance.timeSlots) {
      var newTime = DateTime.parse(
          "${DateTimeExtension.now.year}"
              "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
              "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} $element")
          .toUtc();
      utcSlots.add("${newTime.hour.toString().padLeft(2, "0")}"
          ":${newTime.minute.toString().padLeft(2, "0")}");
    }
    return utcSlots;
  }

  // RxList dayTimeSlots = [].obs;
  // RxList nightTimeSlots = [].obs;

  getSlotsInLocal(){
    for (var element in apiSlots) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse("${DateTimeExtension.now.year}"
          "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
          "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} $element", true);
      var dateLocal = dateTime.toLocal();
      // var dayTimeMax = DateFormat("yyyy-MM-dd HH:mm:ss").parse("${DateTimeExtension.now.year}"
      //     "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
      //     "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} 18:00:00", true);
      //
      // var dayTimeMin = DateFormat("yyyy-MM-dd HH:mm:ss").parse("${DateTimeExtension.now.year}"
      //     "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
      //     "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} 06:00:00", true);

      timeSlots.add("${dateLocal.hour.toString().padLeft(2, "0")}"
          ":${dateLocal.minute.toString().padLeft(2, "0")}");

      print(timeSlots);
    }

  }

  Future saveSlots({List? unavailableDays}) async{
    var result = await repo.saveSlots(
        slots: listInUtc,
        unavailableDays: unavailableDays
    );

    if(result.isRight()){
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Success",
          message: "Saved",
          backgroundColor: ColorPalette.green);
    }
    else{
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: "Couldn't save slots",
          backgroundColor: ColorPalette.red);
    }
  }

  Future getAllSlots() async {
    // loading.value = true;
    Timer.periodic(Duration(seconds: 1), (timer) async{
      var result = await ConsultationRepoImpl().getSlots();

      callTimer = timer;
      call.value++;

      if(result.isRight()){
        callTimer?.cancel();
        timer.cancel();
        // loading.value = false;
        result.map((r){
          //timeSlots.value = r['slots'];
          apiSlots = r['slots'];
          getSlotsInLocal();
        });
        //print(utcToLocal);

      }
      else{
        result.leftMap((l){
          // loading.value = false;
          if(call.value>=6){
            callTimer?.cancel();
            timer.cancel();

            CustomSnackBar.showSnackBar(
                context: Get.context,
                title: "Error",
                message: l.message.toString(),
                backgroundColor: ColorPalette.green);
          }


        });
      }
    });


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

            if(meeting.endAt.isAfter(DateTimeExtension.now)
                && (meeting.startAt.isBefore(DateTimeExtension.now)
                    || meeting.startAt == DateTimeExtension.now))
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
}