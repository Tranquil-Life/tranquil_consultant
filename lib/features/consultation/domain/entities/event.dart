import 'dart:developer';

import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';

class Event {
  final DateTime startAt;
  final DateTime endAt;
  bool isExpired;

  // final DateTime? createdAt;
  final DateTime? updatedAt;

  Event(
      {this.isExpired = false,
      required this.startAt,
      required this.endAt,
      required this.updatedAt});

  int get duration => endAt.difference(startAt).inMinutes;

  setIsExpired(DateTime currentTime) {
    log('END DATE${endAt.formattedTime}');
    log('CURRENT DATE${currentTime.formattedTime}');
    // isExpired = !isExpired;
    isExpired = (currentTime.isAfter(endAt) || currentTime == endAt);
  }
}
