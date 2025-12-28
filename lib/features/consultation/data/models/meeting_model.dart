import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/helpers/timezone_converter.dart';
import 'package:tl_consultant/features/consultation/data/models/client_model.dart';
import 'package:tl_consultant/features/consultation/domain/entities/meeting.dart';

// part 'meeting_model.g.dart';

class MeetingModel extends Meeting {
  MeetingModel({
    required super.id,
    required super.client,
    required super.startAt,
    required super.endAt,
    required super.rescheduled,
    required super.status,
    required super.participants,
    required super.ratedByClient,
    required super.ratedByTherapist,
    // super.reason,
    // super.createdAt,
    //super.updatedAt,
  });

  static bool _isTimeOnly(String s) =>
      RegExp(r'^\d{2}:\d{2}(:\d{2})?$').hasMatch(s.trim());

  static String? _extractDateYmd(Map<String, dynamic> json) {
    // Try common keys your API might include
    final candidates = [
      json['date'],
      json['meeting_date'],
      json['scheduled_date'],
      json['day'],
      json['start_date'],
      json['created_at'], // last resort (not ideal)
    ].where((v) => v != null).map((v) => v.toString()).toList();

    for (final raw in candidates) {
      // ISO or "yyyy-MM-dd ..." -> take first 10 chars
      if (raw.length >= 10) {
        final maybe = raw.substring(0, 10);
        if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(maybe)) return maybe;
      }
    }
    return null;
  }

  static Future<MeetingModel> fromJsonWithTimeZone(Map<String, dynamic> json) async {
    final startRaw = json['start_at'].toString().trim();
    final endRaw = json['end_at'].toString().trim();
    bool ratedByClient = false;
    bool ratedByTherapist = false;

    final dateYmd = _extractDateYmd(json);
    if (dateYmd == null && (_isTimeOnly(startRaw) || _isTimeOnly(endRaw))) {
      throw FormatException(
        'Meeting JSON has time-only start/end but no date field to attach to.',
        json.toString(),
      );
    }

    final localStartAt = _isTimeOnly(startRaw)
        ? await TimeZoneUtil.convertToLocal(dateYmd: dateYmd!, utcHms: startRaw)
        : DateTime.parse(startRaw).toLocal();

    final localEndAt = _isTimeOnly(endRaw)
        ? await TimeZoneUtil.convertToLocal(dateYmd: dateYmd!, utcHms: endRaw)
        : DateTime.parse(endRaw).toLocal();

    if(json['rating'] != null){
      ratedByClient = json['rating']['rating_by_member'] == null ? false : true;
      ratedByTherapist = json['rating']['rating_by_consultant'] == null ? false : true;
    }

    return MeetingModel(
      id: json['id'],
      client: ClientModel.fromJson(json['client']),
      startAt: localStartAt,
      endAt: localEndAt,
        rescheduled: json['rescheduled'] ?? false,
        status: json['status'] ?? "",
        participants: json['participants'] ?? [],
        ratedByClient: ratedByClient,
        ratedByTherapist: ratedByTherapist
    );
  }

}
