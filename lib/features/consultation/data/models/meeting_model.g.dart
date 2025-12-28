// part of 'meeting_model.dart';
//
// fromJsonUsingTimeZone(Map<String, dynamic> json) async {
//   var localStartAt = await TimeZoneUtil.convertToLocal(json['start_at']);
//   var localEndAt = await TimeZoneUtil.convertToLocal(json['end_at']);
//
//   bool ratedByClient = false;
//   bool ratedByTherapist = false;
//
//   if(json['rating'] != null){
//     ratedByClient = json['rating']['rating_by_member'] == null ? false : true;
//     ratedByTherapist = json['rating']['rating_by_consultant'] == null ? false : true;
//   }
//
//
//   return MeetingModel(
//     id: json['id'],
//     client: ClientModel.fromJson(json['client']),
//     startAt: localStartAt ?? DateTime.now(),
//     endAt: localEndAt ?? DateTime.now(),
//     rescheduled: json['rescheduled'] ?? false,
//     status: json['status'] ?? "",
//     participants: json['participants'] ?? [],
//     ratedByClient: ratedByClient,
//     ratedByTherapist: ratedByTherapist
//   );
// }
