import '../database/database_helper.dart';
import '../models/bill.dart';

class BillRepository {
  Future<List<Bill>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'bills',
      where: 'is_active = 1',
      orderBy: 'due_date ASC',
    );
    return rows.map(Bill.fromMap).toList();
  }

  Future<int> insert(Bill bill) async {
    final db = await DatabaseHelper.instance.database;
    final map = bill.toMap()..remove('id');
    return db.insert('bills', map);
  }

  Future<void> update(Bill bill) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'bills',
      bill.toMap(),
      where: 'id = ?',
      whereArgs: [bill.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('bills', where: 'id = ?', whereArgs: [id]);
  }
}