import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tl_consultant/core/constants/us_tz_identifiers.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

class TimeZoneUtil {
  static Future<DateTime> convertToLocal(String utcTime) async {
    final String timeZoneIdentifier =
    await FlutterNativeTimezone.getLocalTimezone();

    // Parse UTC time
    final parsedUtc = DateTime.parse(utcTime).toUtc();

    // Get my timezone
    final location = tz.getLocation(timeZoneIdentifier);

    // Convert UTC -> local time
    final local = tz.TZDateTime.from(parsedUtc, location);

    // print("timezone      : $parsedUtc");
    // print("UTC      : $parsedUtc");
    // print("local    : $local");

    return local;


  }
}
