import 'package:flutter/foundation.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:tl_consultant/core/constants/us_tz_identifiers.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';

// Web-only helpers
import 'dart:html' as html;
import 'dart:js_util' as js_util;


String _getBrowserTimeZone() {
  try {
    final intl = js_util.getProperty(html.window, 'Intl');
    final dtf = js_util.callMethod(intl, 'DateTimeFormat', const []);
    final options = js_util.callMethod(dtf, 'resolvedOptions', const []);
    final tzName = js_util.getProperty(options, 'timeZone');
    if (tzName is String && tzName.isNotEmpty) return tzName;
  } catch (_) {/* ignore */}
  return 'UTC';
}


class TimeZoneUtil {
  static Future<DateTime> convertToLocal({
    required String dateYmd,   // "2025-12-26"
    required String utcHms,    // "09:00:00"
  }) async {
    tzdata.initializeTimeZones();

    final String tzId = kIsWeb
        ? _getBrowserTimeZone()
        : await FlutterNativeTimezone.getLocalTimezone();

    final timeParts = utcHms.split(':');
    if (timeParts.length < 2) {
      throw FormatException('Invalid time format', utcHms);
    }

    final h = int.parse(timeParts[0]);
    final m = int.parse(timeParts[1]);
    final s = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;

    // Build a UTC DateTime using the selected date + utc time
    final date = DateTime.parse(dateYmd); // local midnight, but we only use Y/M/D
    final utc = DateTime.utc(date.year, date.month, date.day, h, m, s);

    final location = tz.getLocation(tzId);
    return tz.TZDateTime.from(utc, location);
  }
}
