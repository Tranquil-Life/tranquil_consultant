import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  static final _dateFormat = DateFormat.yMMMd();
  static final _dateStringFormat = DateFormat('dd-MM-yyyy');
  static final _timeFormat = DateFormat('hh:mma');

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

  String getWeekDay() {
    switch (weekday) {
      case 1:
        return 'MON.';
      case 2:
        return 'TUE.';
      case 3:
        return 'WED.';
      case 4:
        return 'THU.';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT.';
      case 7:
        return 'SUN.';
      default:
        return 'Err';
    }

/*   String timeAgo({DateTime? other, bool numericDates = true}) {
    final difference = (other ?? DateTime.now()).difference(this);
    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
 */
  }
}