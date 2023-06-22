import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  static final _dateFormat = DateFormat.yMMMd();
  static final _dateStringFormat = DateFormat('dd-MM-yyyy');
  static final _timeFormat = DateFormat('hh:mma');
  static final now = DateTime.now();
  String get folded {
    padded(int val) => val.toString().padLeft(2, '0');
    return '${padded(day)}-${padded(month)}-$year';
  }

  String get formatted {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    if (isBefore(today)) return _dateStringFormat.format(this);
    return _timeFormat.format(toLocal());
  }

  String get formatDate {

    return _dateFormat.format(this);
  }
  String get toDateString {

    return _dateStringFormat.format(this);
  }
  String get formattedTime{

    return _timeFormat.format(this);
  }
}