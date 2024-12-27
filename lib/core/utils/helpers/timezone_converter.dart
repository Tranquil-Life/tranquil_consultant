import 'package:timezone/timezone.dart' as tz;
import 'package:tl_consultant/core/constants/us_tz_identifiers.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class TimeZoneUtil {
  static Future<DateTime> convertToLocal(String utcTime) async {
    final timeZoneName = DateTime.now().timeZoneName;
    final timeZoneOffset = DateTime.now().timeZoneOffset;
    var hourInMilliSecs = 3600000;
    var formattedTimeZone = timeZoneOffset.inMilliseconds / hourInMilliSecs;
    Duration offset = Duration(hours: formattedTimeZone.toInt());

    return DateTime.parse(utcTime).add(offset);
  }

  static String getTzIdentifier(
      {required String continent, required String state}) {
    if (centralStates.contains(state)) {
      return central;
    } else if (easternStates.contains(state)) {
      return eastern;
    } else if (mountainStates.contains(state)) {
      return mountain;
    } else if (pacificStates.contains(state)) {
      return pacific;
    } else {
      return "$continent/$state";
    }

  }
}
