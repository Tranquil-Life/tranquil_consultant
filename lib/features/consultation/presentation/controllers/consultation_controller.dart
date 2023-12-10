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

class ConsultationController extends GetxController{
  static ConsultationController instance = Get.find();
  final repo = ConsultationRepoImpl();

  final meetingsStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get meetingsStream => meetingsStreamController.stream;

  var meetingsCount = 0.obs;

  var now = DateTimeExtension.now;
  DateTime? meetingDate;
  var timeSlots = [].obs;
  RxList selectedDays = [].obs;

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

  getSlotsInLocal(){
    for (var element in apiSlots) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse("${DateTimeExtension.now.year}"
          "-${DateTimeExtension.now.month.toString().padLeft(2, "0")}"
          "-${DateTimeExtension.now.day.toString().padLeft(2, "0")} $element", true);
      var dateLocal = dateTime.toLocal();

      timeSlots.add("${dateLocal.hour.toString().padLeft(2, "0")}"
          ":${dateLocal.minute.toString().padLeft(2, "0")}");
    }
  }

  Future saveSlots({List? availableDays}) async{
    var result = await repo.saveSlots(
        slots: listInUtc,
        availableDays: availableDays
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
    loading.value = true;

    var result = await ConsultationRepoImpl().getSlots();

    if(result.isRight()){
      loading.value = false;

      result.map((r){
        apiSlots = r['slots'];
        availableDays(r['days']);

        getSlotsInLocal();
      });
    }
    else{
      loading.value = false;
      instance.timeSlots.clear();
    }
  }

  Future getMeetings() async{
     loading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    var result = await ConsultationRepoImpl().getMeetings();

    if(result.isRight()){
      List<Meeting> meetings = [];

      result.map((r){
        for (var element in r) {
          Meeting meeting = MeetingModel.fromJson(element);
          meetings.add(meeting);

          if(meeting.endAt.isAfter(now)
              && (meeting.startAt.isBefore(now) || meeting.startAt == now))
          {
            DashboardController.instance.currentMeetingCount.value = 1;

            DashboardController.instance.currentMeetingId.value = meeting.id;
            DashboardController.instance.clientId.value = meeting.client.id;
            DashboardController.instance.clientDp.value = meeting.client.avatarUrl;
            DashboardController.instance.clientName.value = meeting.client.displayName;
            DashboardController.instance.currentMeetingST.value = meeting.startAt.formatDate;
            DashboardController.instance.currentMeetingET.value = meeting.endAt.formatDate;
          }
        }
      });

      Map<String, dynamic> values = {
        "meetings": meetings,
        "num_of_meetings": meetings.length,
      };

      meetingsCount.value = meetings.length;

      if (!meetingsStreamController.isClosed) meetingsStreamController.sink.add(values);
    }
    else{
      result.leftMap((l){
        CustomSnackBar.showSnackBar(
            context: Get.context!,
            title: 'Error',
            message: l.message!,
            backgroundColor: ColorPalette.red);
      });
    }

    loading.value = true;

    update();
  }

  availableDays(Map<String, dynamic> daysMap) {
    selectedDays.value = daysMap.keys.map((e){
      if(daysMap[e] == true) return e.capitalizeFirst;
    }).toList().where((element) => element != null).toList();
  }

  void clearData() {}
}