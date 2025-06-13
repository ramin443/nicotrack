import 'package:intl/intl.dart';

String convertDatetoUsableFormat(String dateString) {
  try {
    DateTime parsedDate = DateTime.parse(dateString);

    String dayWithOrdinal = getDayWithOrdinal(parsedDate.day);
    String monthName =
        DateFormat.MMMM().format(parsedDate); // Full month name (e.g., "May")
    String year = DateFormat.y().format(parsedDate); // Year (e.g., "2025")
    return '$dayWithOrdinal $monthName, $year';
  } catch (e) {
    print("Error parsing or formatting date: $e");
    return "Invalid Date"; // Or handle the error as appropriate
  }
}

String getDayWithOrdinal(int day) {
  if (day <= 0 || day > 31) {
    throw ArgumentError('Invalid day: $day');
  }
  if (day >= 11 && day <= 13) {
    return '${day}th';
  }
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}