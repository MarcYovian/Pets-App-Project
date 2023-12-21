import 'package:intl/intl.dart';

String formatTimestamp(DateTime timestamp) {
  String convertedDate = DateFormat.jm().format(timestamp);

  return convertedDate;
}
