import "package:intl/intl.dart";

class DateTimeUtils {
  static String format(DateTime dateTime) {
    return DateFormat("EEE, MMM d").format(dateTime);
  }
  
  static DateTime parse(String dateString) {
    return DateFormat("EEE, MMM d").parse(dateString);
  }
}
