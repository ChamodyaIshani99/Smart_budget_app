import '../../core/utils/helpers.dart';
import '../../data/models/bill.dart';

class DashboardData {
  final List<Bill> overdue;
  final List<Bill> upcoming; // today up to 30 days ahead
  final Map<String, double> overdueTotals;
  final Map<String, double> toPayThisMonth;

  const DashboardData({
    required this.overdue,
    required this.upcoming,
    required this.overdueTotals,
    required this.toPayThisMonth,
  });

  /// [bills] must already be sorted by due date (the repository does this).
  factory DashboardData.from(List<Bill> bills, DateTime now) {
    final today = dateOnly(now);
    final monthEnd = DateTime(today.year, today.month + 1, 0);
    final horizon = DateTime(today.year, today.month, today.day + 30);

    final overdue = <Bill>[];
    final upcoming = <Bill>[];
    final overdueTotals = <String, double>{};
    final toPay = <String, double>{};

    void add(Map<String, double> m, Bill b) =>
        m.update(b.currency, (v) => v + b.amount, ifAbsent: () => b.amount);

    for (final b in bills) {
      final due = dateOnly(b.dueDate);
      if (due.isBefore(today)) {
        overdue.add(b);
        add(overdueTotals, b);
      } else {
        if (!due.isAfter(horizon)) upcoming.add(b);
        if (!due.isAfter(monthEnd)) add(toPay, b);
      }
    }

    return DashboardData(
      overdue: overdue,
      upcoming: upcoming,
      overdueTotals: overdueTotals,
      toPayThisMonth: toPay,
    );
  }
}