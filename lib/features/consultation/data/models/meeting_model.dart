import 'package:tl_consultant/features/consultation/data/models/client_model.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';

part 'meeting_model.g.dart';

class MeetingModel extends Meeting{
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

  factory MeetingModel.fromJson(Map<String, dynamic> json) => _$MeetingModelFromJson(json);
}