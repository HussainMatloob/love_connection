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

  static int calculateAge(String dateOfBirth) {
    DateTime birthDate = DateTime.parse(dateOfBirth);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    // Check if birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  static String getDate(String dateTime) {
    String onlyDate = dateTime.split(' ')[0];
    return onlyDate;
  }
}
