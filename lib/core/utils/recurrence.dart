import 'dart:math';
import '../../data/models/bill.dart';

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// Returns the next due date after [current].
/// [anchorDay] is the bill's original day of month (e.g. 31).
DateTime nextDueDate(DateTime current, Recurrence recurrence, int anchorDay) {
  switch (recurrence) {
    case Recurrence.none:
      return current;
    case Recurrence.monthly:
      final year = current.month == 12 ? current.year + 1 : current.year;
      final month = current.month == 12 ? 1 : current.month + 1;
      return DateTime(year, month, min(anchorDay, daysInMonth(year, month)));
    case Recurrence.yearly:
      final year = current.year + 1;
      return DateTime(
        year,
        current.month,
        min(anchorDay, daysInMonth(year, current.month)),
      );
  }
}