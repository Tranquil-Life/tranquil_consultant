import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  var call = 0.obs;
  Timer? callTimer;

  var meetingsCount = 0.obs;

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
    Timer.periodic(const Duration(seconds: 1), (timer) async{
      var result = await ConsultationRepoImpl().getSlots();

      callTimer = timer;
      call.value++;

      if(result.isRight()){
        loading.value = false;

        callTimer?.cancel();
        timer.cancel();

        result.map((r){
          apiSlots = r['slots'];
          availableDays(r['days']);

          print(r['days']);
          getSlotsInLocal();
        });
      }
      else{
        loading.value = false;
        result.leftMap((l){
          if(call.value>=6){
            callTimer?.cancel();
            timer.cancel();
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
          if(call.value>=10) {
            callTimer?.cancel();
            timer.cancel();
          }}
        );
      }
    });
  }

  availableDays(Map<String, dynamic> daysMap) {
    selectedDays.value = daysMap.keys.map((e){
      if(daysMap[e] == true) return e.capitalizeFirst;
    }).toList().where((element) => element != null).toList();
  }


  @override
  void onClose() {
    callTimer?.cancel();

    super.onClose();
  }
}