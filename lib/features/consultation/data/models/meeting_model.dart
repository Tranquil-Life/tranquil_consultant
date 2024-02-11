import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/features/consultation/data/models/client_model.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';

part 'meeting_model.g.dart';

class MeetingModel extends Meeting {
  MeetingModel({
    required super.id,
    required super.client,
    required super.startAt,
    required super.endAt,
    required super.rescheduled,
    required super.status,
    required super.participants,
    // super.reason,
    // super.createdAt,
    //super.updatedAt,
  });

  static Future<MeetingModel> fromJsonWithTimeZone(
      Map<String, dynamic> json) async {
    return await fromJsonUsingTimeZone(json);
  }
}
