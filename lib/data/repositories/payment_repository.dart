import '../../core/utils/recurrence.dart';
import '../database/database_helper.dart';
import '../models/bill.dart';
import '../models/payment.dart';

class PaymentRepository {
  Future<List<Payment>> getForBill(int billId) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'payments',
      where: 'bill_id = ?',
      whereArgs: [billId],
      orderBy: 'paid_date DESC, id DESC',
    );
    return rows.map(Payment.fromMap).toList();
  }

  /// Records the payment and moves the bill forward, in one transaction.
  Future<void> markAsPaid(Bill bill, double amountPaid) async {
    final db = await DatabaseHelper.instance.database;
    await db.transaction((txn) async {
      await txn.insert('payments', {
        'bill_id': bill.id,
        'amount_paid': amountPaid,
        'currency': bill.currency,
        'paid_date': DateTime.now().toIso8601String(),
        'due_date_covered': bill.dueDate.toIso8601String(),
      });

      if (bill.recurrence == Recurrence.none) {
        // One-time bill: archive it (payment history is kept)
        await txn.update('bills', {'is_active': 0},
            where: 'id = ?', whereArgs: [bill.id]);
      } else {
        final next =
            nextDueDate(bill.dueDate, bill.recurrence, bill.anchorDay);
        await txn.update('bills', {'due_date': next.toIso8601String()},
            where: 'id = ?', whereArgs: [bill.id]);
      }
    });
  }

    /// Total paid in the month of [month], grouped by currency.
  Future<Map<String, double>> totalsForMonth(DateTime month) async {
    final db = await DatabaseHelper.instance.database;
    final start = DateTime(month.year, month.month, 1).toIso8601String();
    final end = DateTime(month.year, month.month + 1, 1).toIso8601String();
    final rows = await db.rawQuery(
      'SELECT currency, SUM(amount_paid) AS total FROM payments '
      'WHERE paid_date >= ? AND paid_date < ? GROUP BY currency',
      [start, end],
    );
    return {
      for (final r in rows)
        r['currency'] as String: (r['total'] as num).toDouble(),
    };
  }
}