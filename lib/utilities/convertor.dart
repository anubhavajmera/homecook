import 'package:intl/intl.dart';

String formatTimestamp(timestamp) {
  timestamp = DateTime.parse(timestamp);
  return DateFormat('dd-MM-yyyy hh:mm a').format(timestamp);
}
