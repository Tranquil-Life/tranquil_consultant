import 'package:timezone/timezone.dart' as tz;
import 'package:tl_consultant/core/constants/us_tz_identifiers.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class TimeZoneUtil {
  static Future<DateTime> convertToLocal(String utcTime) async {
    print("TZ IDENTIFIER: ${userDataStore.user['timezone_identifier']}");
    final location =
        tz.getLocation("${userDataStore.user['timezone_identifier']}");
    var timeZone = location.currentTimeZone;

    var hourInMilliSecs = 3600000;
    var formattedTimeZone = timeZone.offset / hourInMilliSecs;
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
