import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return DateFormat("EEE, MMM d, y").format(date);
  }
  
  static DateTime unformatDate(String date) {
    return DateFormat("EEE, MMM d, y").parse(date);
  }

  static DateTime getWeekStart() {
    final DateTime today = DateTime.now();
    return DateTime(today.year, today.month, today.day - (today.weekday - DateTime.monday));
  }

  static DateTime getWeekEnd() {
    final DateTime start = getWeekStart();
    return start.add(Duration(days: 7)).subtract(Duration(milliseconds: 1));
  }

  static bool isInCurrentWeek(DateTime date) {
    final DateTime start = getWeekStart();
    final DateTime end = getWeekEnd();    
    return !date.isBefore(start) && !date.isAfter(end);
  }

}
