import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/functions.dart';
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

  static Future<MeetingModel> fromJsonWithTimeZone(
      Map<String, dynamic> json) async {
    final startRaw = json['start_at'].toString().trim();
    final endRaw = json['end_at'].toString().trim();
    bool ratedByClient = false;
    bool ratedByTherapist = false;

    final dateYmd = extractDateYmd(json);
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

    //Added 1 hour to fix timezone issue from backend
    // final patchedStartAt = localStartAt.add(const Duration(hours: 1));
    // final patchedEndAt = localEndAt.add(const Duration(hours: 1));

    if (json['rating'] != null) {
      ratedByClient = json['rating']['rating_by_member'] == null ? false : true;
      ratedByTherapist =
          json['rating']['rating_by_consultant'] == null ? false : true;
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
        ratedByTherapist: ratedByTherapist);
  }
}
