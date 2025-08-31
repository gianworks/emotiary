import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return DateFormat("EEE, MMM d, y").format(date);
  }
  
}
