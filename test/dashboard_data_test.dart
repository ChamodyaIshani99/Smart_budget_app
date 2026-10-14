import 'package:flutter_test/flutter_test.dart';
import 'package:smart_budget/data/models/bill.dart';
import 'package:smart_budget/features/dashboard/dashboard_data.dart';

Bill bill(DateTime due, double amount, {String currency = 'LKR'}) => Bill(
      title: 't',
      amount: amount,
      currency: currency,
      categoryId: 1,
      dueDate: due,
    );

void main() {
  final now = DateTime(2026, 10, 14, 15, 30);

  test('splits overdue, this month and later', () {
    final data = DashboardData.from([
      bill(DateTime(2026, 10, 13), 100), // overdue
      bill(DateTime(2026, 10, 14), 200), // due today
      bill(DateTime(2026, 10, 31), 300), // last day of this month
      bill(DateTime(2026, 11, 1), 400),  // next month
    ], now);

    expect(data.overdue.length, 1);
    expect(data.overdueTotals['LKR'], 100);
    expect(data.toPayThisMonth['LKR'], 500); // 200 + 300, not 400
    expect(data.upcoming.length, 3);
  });

  test('upcoming includes day 30 but not day 31', () {
    final data = DashboardData.from([
      bill(DateTime(2026, 11, 13), 1),
      bill(DateTime(2026, 11, 14), 1),
    ], now);
    expect(data.upcoming.length, 1);
  });

  test('currencies are never mixed', () {
    final data = DashboardData.from([
      bill(DateTime(2026, 10, 20), 1000),
      bill(DateTime(2026, 10, 21), 25, currency: 'USD'),
    ], now);
    expect(data.toPayThisMonth['LKR'], 1000);
    expect(data.toPayThisMonth['USD'], 25);
  });
}