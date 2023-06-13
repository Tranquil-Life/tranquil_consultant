import 'dart:io';
import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/config.dart';
import 'package:tl_consultant/app/presentation/widgets/IOSDatePicker.dart';

void setStatusBarBrightness(bool dark, [Duration? delayedTime]) async {
  await Future.delayed(delayedTime ?? const Duration(milliseconds: 300));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: dark ? Brightness.dark : Brightness.light,
    statusBarBrightness: dark ? Brightness.light : Brightness.dark,
  ));
}

List timeOfDayRange(List slots){
  List newArray = [];
  final format = DateFormat('HH:mm');

  for (int i = 1; i < slots.length; i++) {
    if(slots[i].hour >= 6 && slots[i].hour <=18){

      newArray.add(format.format(slots[i]));
    }
  }

  return newArray;
}

List timeOfNightRange(List slots){
  List newArray = [];
  final format = DateFormat('HH:mm');

  for (var element in slots) {
    if(element.hour <= 5 || element.hour >=19){

      newArray.add(format.format(element));
    }
  }

  return newArray;
}

Future<bool> addMeetingToCalendar(DateTime time,
    {required String c_fname, required String c_lname}) {
  return Add2Calendar.addEvent2Cal(Event(
    title: 'TL consultation with $c_fname $c_lname',
    description:
    'This is a scheduled meeting with a consultant on ${AppConfig.appName}',
    location: AppConfig.appName,
    startDate: time,
    endDate: time.add(const Duration(hours: 1)),
    androidParams: const AndroidParams(),
    iosParams: const IOSParams(reminder: Duration(hours: 2)),
  ));
}

Future<DateTime?> showCustomDatePicker(BuildContext context,
    {DateTime? minDateFromNow, DateTime? maxDateFromNow}) {
  var now = DateTime.now();

  var min = DateTime(
    now.year + (minDateFromNow?.year ?? 0),
    now.month + (minDateFromNow?.month ?? 0),
    now.day,
  );
  var max = DateTime(
    now.year + maxDateFromNow!.year,
    now.month + maxDateFromNow.month,
    now.day,
  );

  final initial = now.isBefore(max) ? now : max;

  if (Platform.isIOS) {
    return showModalBottomSheet<DateTime>(
      context: context,
      builder: (_) =>
          IOSDatePicker(
              minDate: min,
              maxDate: max,
              initialDate: initial
          ),
    );
  }
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: min,
    lastDate: max,
  );
}

String strMsgType(String messageType){
  switch (messageType) {
    case "MessageType.text":
      return 'text';
    case "MessageType.image":
      return 'image';
    case "MessageType.video":
      return 'video';
    case "MessageType.audio":
      return 'audio';
    default:
      return 'text';
  }
}

Future getFileSize(String filepath, int decimals) async {
  var file = File(filepath);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();

  if(suffixes[i] != "B" && suffixes[i] !="KB"){
    if((bytes / pow(1024, i)) > 2){
      return "Too large";
    }else{
      return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
    }
  }else{
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
