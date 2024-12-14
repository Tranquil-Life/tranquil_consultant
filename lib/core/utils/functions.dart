import 'dart:io';
import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:tl_consultant/app/config.dart';
import 'package:tl_consultant/app/presentation/widgets/IOSDatePicker.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';

void setStatusBarBrightness(bool dark, [Duration? delayedTime]) async {
  await Future.delayed(delayedTime ?? const Duration(milliseconds: 300));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: dark ? Brightness.dark : Brightness.light,
    statusBarBrightness: dark ? Brightness.light : Brightness.dark,
  ));
}

List timeOfDayRange() {
  return List.generate(19, (index) {
    if (index >= 6 && index <= 18)
      return "${index.toString().padLeft(2, "0")}:00";
  }).where((element) => element != null).toList();
}

List timeOfNightRange() {
  return List.generate(24, (index) {
    if (index <= 5 || index >= 19)
      return "${index.toString().padLeft(2, "0")}:00";
  }).where((element) => element != null).toList();
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
          IOSDatePicker(minDate: min, maxDate: max, initialDate: initial),
    );
  }
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: min,
    lastDate: max,
  );
}

String strMsgType(String messageType) {
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

  if (suffixes[i] != "B" && suffixes[i] != "KB") {
    if ((bytes / pow(1024, i)) > 2) {
      return "Too large";
    } else {
      return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
    }
  } else {
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}

Future<Map<String, dynamic>> getCurrLocation() async {
  late Position position;
  // Request location permissions
  LocationPermission permission = await Geolocator.requestPermission();
  List<Placemark> placemarks = [];
  if (permission == LocationPermission.denied) {
    print("Location permission denied");
  } else {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    // Use geocoding to get the placemarks for the current location
    placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
  }

  var data = <String, dynamic>{
    "latitude": position.latitude,
    "longitude": position.longitude,
    "placemarks": placemarks
  };

  return data;
}

List<TextSpan> parseNoteText(String text) {
  RegExp regExpBold = RegExp(r'\*\*(.*?)\*\*');
  RegExp regExpItalic = RegExp(r'\b_(.*?)_\b');
  List<TextSpan> spans = [];
  List<String> words = text.split(' ');

  for (String word in words) {
    if (regExpBold.hasMatch(word)) {
      spans.add(TextSpan(
        text: "${word.replaceAll('**', '')} ",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
    } else if (regExpItalic.hasMatch(word)) {
      spans.add(TextSpan(
        text: "${word.replaceAll('_', '')} ",
        style: const TextStyle(fontStyle: FontStyle.italic),
      ));
    } else {
      spans.add(TextSpan(text: '$word '));
    }
  }
  return spans;
}

int calculateAge(String birthDate) {
  // Parse the input string to a DateTime object
  DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(birthDate);

  // Get today's date
  DateTime today = DateTime.now();

  // Calculate the difference in years
  int age = today.year - parsedDate.year;

  // Adjust for cases where the birthday hasn't occurred yet this year
  if (today.month < parsedDate.month ||
      (today.month == parsedDate.month && today.day < parsedDate.day)) {
    age--;
  }

  return age;
}
