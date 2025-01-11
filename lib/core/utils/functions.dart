import 'dart:io';
import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tl_consultant/app/config.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/IOSDatePicker.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_snackbar.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';


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
  Position position;
  // Request location permissions
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    print("Location permission denied");
    return {"error": "Location permission denied"};
  }

  // Get current position
  position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );

  // Use geocoding to get the placemarks
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  return {
    "latitude": position.latitude,
    "longitude": position.longitude,
    "placemarks": placemarks,
  };
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

String formatDuration(double milliseconds) {
  int totalSeconds = (milliseconds ~/ 1000); // Convert to total seconds
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

Future shareFile(File toShare) async {
  try {
    final file = File(toShare.path);  // Ensure you're passing the correct path

    // Debugging the file path and existence
    // print('File path: ${file.path}');
    // print('File exists: ${file.existsSync()}');

    // Check if the file exists before trying to share
    if (file.existsSync()) {
      await Share.shareXFiles([XFile(file.path)]);
    } else {
      CustomSnackBar.showSnackBar(
          context: Get.context!,
          title: "Error",
          message: "File does not exist",
          backgroundColor: ColorPalette.red);
    }
  } catch (e) {
    CustomSnackBar.showSnackBar(
        context: Get.context!,
        title: "Error",
        message: "Failed to share video",
        backgroundColor: ColorPalette.red);
  }
}

Future<Map<String, dynamic>> convertFilesToMultipart(
    Map<String, dynamic> data) async {
  Map<String, dynamic> newData = Map<String, dynamic>.from(data);

  // Iterate over the map and check for keys with File values
  for (String key in newData.keys) {
    if (newData[key] is File) {
      File file = newData[key] as File;

      // Replace the file with a MultipartFile
      newData[key] = await dio.MultipartFile.fromFile(
        file.path,
        filename: basename(file.path), // Extract filename from path
      );
    }
  }

  return newData;
}

String truncateWithEllipsis(int maxLength, String text) {
  return (text.length <= maxLength)
      ? text
      : '${text.substring(0, maxLength)}...';
}

List<String> getTitlesAfterComma(String input) {
  // Split the string at the first comma
  List<String> parts = input.split(',');

  if (parts.length < 2) {
    // If there's no comma or no content after the comma, return an empty list
    return [];
  }

  // Get everything after the first comma
  String titlesPart = parts.sublist(1).join(',');

  // Split the titles part into individual titles and trim whitespace
  return titlesPart.split(',').map((title) => title.trim()).toList();
}

checkForEmptyProfileInfo(ProfileController profileController) async {
  await Future.delayed(Duration(seconds: 2));
  profileController.getQualifications();
  User user = UserModel.fromJson(userDataStore.user);
  if (user.firstName.isEmpty ||
      user.bio.isEmpty ||
      user.specialties!.isEmpty ||
      user.videoIntroUrl!.isEmpty ||
      profileController.qualifications.isEmpty) {
    Get.to(() => EditProfileScreen());
  }
}
