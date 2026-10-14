import 'package:flutter_test/flutter_test.dart';
import 'package:smart_budget/core/utils/recurrence.dart';
import 'package:smart_budget/data/models/bill.dart';

void main() {
  test('monthly: Jan 31 -> Feb 28 (non-leap year)', () {
    final next = nextDueDate(DateTime(2027, 1, 31), Recurrence.monthly, 31);
    expect(next, DateTime(2027, 2, 28));
  });

  test('monthly: Jan 31 -> Feb 29 (leap year)', () {
    final next = nextDueDate(DateTime(2028, 1, 31), Recurrence.monthly, 31);
    expect(next, DateTime(2028, 2, 29));
  });

  test('monthly: returns to the 31st after February', () {
    final next = nextDueDate(DateTime(2027, 2, 28), Recurrence.monthly, 31);
    expect(next, DateTime(2027, 3, 31));
  });

  test('monthly: December rolls into January of next year', () {
    final next = nextDueDate(DateTime(2026, 12, 15), Recurrence.monthly, 15);
    expect(next, DateTime(2027, 1, 15));
  });

  test('yearly: Feb 29 -> Feb 28 in a non-leap year', () {
    final next = nextDueDate(DateTime(2028, 2, 29), Recurrence.yearly, 29);
    expect(next, DateTime(2029, 2, 28));
  });

  test('one-time bill does not move', () {
    final d = DateTime(2026, 10, 14);
    expect(nextDueDate(d, Recurrence.none, 14), d);
  });
}