
part of 'meeting_model.dart';

MeetingModel _$MeetingModelFromJson(Map<String, dynamic> json) => MeetingModel(
  id: json['id'],
  client: ClientModel.fromJson(json['client']),
  startAt: DateTime.parse(json['start_at']) ?? DateTime.now(),
  endAt: DateTime.parse(json['end_at'])  ?? DateTime.now(),
  //updatedAt: DateTime.parse(json['updated_at'])  ?? DateTime.now(),
  rescheduled: json['rescheduled'] ?? false,
  status: json['status'] ?? "",
  // participants: json['participants'] ?? [],
);