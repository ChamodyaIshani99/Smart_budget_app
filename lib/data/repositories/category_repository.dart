import '../database/database_helper.dart';
import '../models/category.dart';

class CategoryRepository {
  Future<List<Category>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('categories', orderBy: 'id ASC');
    return rows.map(Category.fromMap).toList();
  }
}