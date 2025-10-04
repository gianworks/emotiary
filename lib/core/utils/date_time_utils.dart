import "package:intl/intl.dart";

class DateTimeUtils {
  static String format(DateTime date) => DateFormat("EEE, MMM d, y").format(date);

  static DateTime parse(String dateString) => DateFormat("EEE, MMM d, y").parse(dateString);

  static bool isSameDate(DateTime a, DateTime b) => a.month == b.month && a.day == b.day;

  static String formateRelativeDate(String dateString) {
    final DateTime entryDate = parse(dateString);

    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(Duration(days: 1));

    if (isSameDate(entryDate, now)) return "Today";
    if (isSameDate(entryDate, yesterday)) return "Yesterday";

    return DateFormat("EEE, MMM d").format(entryDate);
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
