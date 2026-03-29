import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final _displayFormat = DateFormat('MMM d, yyyy');
  static final _shortFormat = DateFormat('MMM d');

  /// Parses an ISO-8601 string and returns a human-readable date.
  /// Returns 'No due date' gracefully if the string is null or malformed.
  static String format(String? iso, {bool short = false}) {
    if (iso == null || iso.isEmpty) return 'No due date';
    try {
      final date = DateTime.parse(iso).toLocal();
      return short ? _shortFormat.format(date) : _displayFormat.format(date);
    } catch (_) {
      return 'Invalid date';
    }
  }

  /// Returns true if the date is in the past (overdue).
  static bool isOverdue(String? iso) {
    if (iso == null || iso.isEmpty) return false;
    try {
      return DateTime.parse(iso).toLocal().isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }
}
