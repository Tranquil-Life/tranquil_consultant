import 'dart:developer';

import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/features/consultation/data/models/client_model.dart';
import 'package:tl_consultant/features/consultation/domain/entities/participant.dart';

class Meeting {
  final int id;
  final ClientModel client;
  //
  final bool rescheduled;
  final String reason;
  final String status;
  bool isExpired;
  final List<Participant> participants;
  final DateTime startAt;
  final DateTime endAt;
  final bool ratedByClient;
  final bool ratedByTherapist;

  int get duration => endAt.difference(startAt).inMinutes;

  void setIsExpired(DateTime currentTime) {
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
        this.isExpired = false,
        this.reason = "",
        required this.participants,
        this.status = "",
        required this.ratedByClient,
        required this.ratedByTherapist,
      });

  Map<String, dynamic> toJson() => {
    "id": id,
    "rescheduled": rescheduled,
    "status": status,
    "reason": reason,
    "start_at": startAt,
    "end_at": endAt,
  };
}