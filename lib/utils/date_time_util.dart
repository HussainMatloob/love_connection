import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateTime setDateOfBirth(String dateString) {
    try {
      final parsedDate = DateTime.parse(dateString); // This handles ISO format
      return parsedDate;
    } catch (e) {
      return DateFormat('dd/MM/yyyy').parse('03/08/2002');
    }
  }
}
