import '../database/database_helper.dart';
import '../models/category.dart';

class CategoryTotal {
  final Category category;
  final double total;
  final int count;
  const CategoryTotal({
    required this.category,
    required this.total,
    required this.count,
  });
}

class MonthTotal {
  final DateTime month;
  final double total;
  const MonthTotal(this.month, this.total);
}

class ReportRepository {
  /// Currencies that have at least one payment.
  Future<List<String>> currencies() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db
        .rawQuery('SELECT DISTINCT currency FROM payments ORDER BY currency');
    return rows.map((r) => r['currency'] as String).toList();
  }

  /// Spending per category for one month and one currency, biggest first.
  Future<List<CategoryTotal>> categoryTotals(
      DateTime month, String currency) async {
    final db = await DatabaseHelper.instance.database;
    final start = DateTime(month.year, month.month, 1).toIso8601String();
    final end = DateTime(month.year, month.month + 1, 1).toIso8601String();

    final rows = await db.rawQuery('''
      SELECT c.id, c.name_en, c.name_si, c.icon, c.color,
             SUM(p.amount_paid) AS total, COUNT(p.id) AS cnt
      FROM payments p
      JOIN bills b ON b.id = p.bill_id
      JOIN categories c ON c.id = b.category_id
      WHERE p.paid_date >= ? AND p.paid_date < ? AND p.currency = ?
      GROUP BY c.id
      ORDER BY total DESC
    ''', [start, end, currency]);

    return rows
        .map((r) => CategoryTotal(
              category: Category.fromMap(r),
              total: (r['total'] as num).toDouble(),
              count: r['cnt'] as int,
            ))
        .toList();
  }

  /// Monthly totals for the [months] months ending at [endMonth].
  /// Months with no payments are included with a total of 0.
  Future<List<MonthTotal>> monthlyTotals(
    DateTime endMonth,
    String currency, {
    int months = 6,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final first = DateTime(endMonth.year, endMonth.month - (months - 1), 1);
    final end = DateTime(endMonth.year, endMonth.month + 1, 1);

    final rows = await db.rawQuery('''
      SELECT substr(paid_date, 1, 7) AS ym, SUM(amount_paid) AS total
      FROM payments
      WHERE paid_date >= ? AND paid_date < ? AND currency = ?
      GROUP BY ym
    ''', [first.toIso8601String(), end.toIso8601String(), currency]);

    final byKey = {
      for (final r in rows) r['ym'] as String: (r['total'] as num).toDouble(),
    };

    return List.generate(months, (i) {
      final m = DateTime(first.year, first.month + i, 1);
      final key = '${m.year}-${m.month.toString().padLeft(2, '0')}';
      return MonthTotal(m, byKey[key] ?? 0);
    });
  }
}