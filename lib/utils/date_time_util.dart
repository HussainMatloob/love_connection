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

  // static int calculateAge(String dateOfBirth) {
  //   DateTime birthDate = DateTime.parse(dateOfBirth);
  //   DateTime today = DateTime.now();

  //   int age = today.year - birthDate.year;

  //   // Check if birthday hasn't occurred yet this year
  //   if (today.month < birthDate.month ||
  //       (today.month == birthDate.month && today.day < birthDate.day)) {
  //     age--;
  //   }

  //   return age;
  // }
  /// Attempts to parse a string in multiple common formats
  static DateTime? tryParseDate(String input) {
    List<String> formats = [
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'yyyy-MM-dd',
      'yyyy-MM-ddTHH:mm:ss',
      'yyyy-MM-ddTHH:mm:ss.SSS',
      'yyyy-MM-ddTHH:mm:ss.SSSZ',
    ];

    for (String format in formats) {
      try {
        return DateFormat(format).parseStrict(input);
      } catch (_) {
        // continue trying other formats silently
      }
    }

  try {
      // Fallback for ISO 8601 format
      return DateTime.parse(input);
    } catch (_) {
      return null;
    }
  }

  static int calculateAge(String rawDate) {
    DateTime? birthDate = tryParseDate(rawDate);
    if (birthDate == null) throw FormatException("Invalid date format");

    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

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
