import 'dart:developer';

import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/consultation/data/models/client_model.dart';

class Meeting {
  final int id;
  final ClientModel client;
  //
  final bool rescheduled;
  final String reason;
  final String status;
  bool isExpired;
  // final List participants;
  final DateTime startAt;
  final DateTime endAt;
  // final DateTime? createdAt;
  final DateTime? updatedAt;

  int get duration => endAt.difference(startAt).inMinutes;

  setIsExpired(DateTime currentTime) {
    log('END DATE${endAt.formattedTime}');
    log('CURRENT DATE${currentTime.formattedTime}');
    // isExpired = !isExpired;
    isExpired = (currentTime.isAfter(endAt) || currentTime == endAt);
  }

  Meeting(
      {required this.id,
        required this.client,
        required this.startAt,
        required this.endAt,
        required this.rescheduled,
        // this.createdAt,
        this.updatedAt,
        this.isExpired = false,
        this.reason = "",
        // required this.participants,
        this.status = ""
      });

  Map<String, dynamic> toJson() => {
    "id": id,
    "rescheduled": rescheduled,
    "status": status,
    "reason": reason,
  };
}