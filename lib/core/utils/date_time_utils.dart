import "package:intl/intl.dart";

class DateTimeUtils {
  static String format(DateTime date) => DateFormat("EEE, MMM d").format(date);
  static DateTime parse(String dateString) => DateFormat("EEE, MMM d").parse(dateString);

  static bool isSameDate(DateTime a, DateTime b) => a.month == b.month && a.day == b.day;

  static String formateRelativeDate(String dateString) {
    final DateTime entryDate = parse(dateString);

    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(Duration(days: 1));

    if (isSameDate(entryDate, now)) return "Today";
    if (isSameDate(entryDate, yesterday)) return "Yesterday";

    return dateString;
  }
}
