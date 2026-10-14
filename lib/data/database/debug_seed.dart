import 'dart:math';
import 'database_helper.dart';

class DebugSeed {
  /// Creates hidden "Sample:" bills with payments over the last 6 months.
  static Future<void> addSamplePayments() async {
    final db = await DatabaseHelper.instance.database;
    final cats = await db.query('categories', orderBy: 'id ASC');
    final rnd = Random(7);
    final now = DateTime.now();

    Future<void> seed(
      dynamic txn,
      Map<String, Object?> cat,
      String currency,
      int months,
      int minAmount,
      int spread,
    ) async {
      final billId = await txn.insert('bills', {
        'title': 'Sample: ${cat['name_en']} ($currency)',
        'amount': minAmount.toDouble(),
        'currency': currency,
        'category_id': cat['id'],
        'due_date': now.toIso8601String(),
        'recurrence': 'none',
        'reminder_days': 0,
        'is_active': 0, // hidden from the bill lists
        'anchor_day': now.day,
      });
      for (var m = 0; m < months; m++) {
        final paid = DateTime(now.year, now.month - m, 1, 12);
        await txn.insert('payments', {
          'bill_id': billId,
          'amount_paid': (minAmount + rnd.nextInt(spread)).toDouble(),
          'currency': currency,
          'paid_date': paid.toIso8601String(),
          'due_date_covered': paid.toIso8601String(),
        });
      }
    }

    await db.transaction((txn) async {
      for (final c in cats.take(5)) {
        await seed(txn, c, 'LKR', 6, 2000, 8000);
      }
      await seed(txn, cats[4], 'USD', 3, 20, 40); // Internet, USD
    });
  }

  /// Deleting the sample bills also deletes their payments (cascade).
  static Future<void> removeSamples() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('bills', where: "title LIKE 'Sample:%'");
  }
}