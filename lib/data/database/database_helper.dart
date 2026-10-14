import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/constants/app_constants.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);
    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name_en TEXT NOT NULL,
        name_si TEXT NOT NULL,
        icon TEXT NOT NULL,
        color INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        due_date TEXT NOT NULL,
        recurrence TEXT NOT NULL DEFAULT 'none',
        reminder_days INTEGER NOT NULL DEFAULT 3,
        notes TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        anchor_day INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bill_id INTEGER NOT NULL,
        amount_paid REAL NOT NULL,
        currency TEXT NOT NULL,
        paid_date TEXT NOT NULL,
        due_date_covered TEXT NOT NULL,
        FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_bills_due ON bills (due_date)');
    await db.execute('CREATE INDEX idx_payments_paid ON payments (paid_date)');

    await _seedCategories(db);
  }

  Future<void> _seedCategories(Database db) async {
    final cats = [
      {'name_en': 'Electricity', 'name_si': 'විදුලිය', 'icon': 'bolt', 'color': 0xFFFFA000},
      {'name_en': 'Water', 'name_si': 'ජලය', 'icon': 'water', 'color': 0xFF039BE5},
      {'name_en': 'Loan', 'name_si': 'ණය', 'icon': 'bank', 'color': 0xFF8E24AA},
      {'name_en': 'Rent', 'name_si': 'කුලිය', 'icon': 'home', 'color': 0xFF6D4C41},
      {'name_en': 'Internet/Phone', 'name_si': 'අන්තර්ජාල/දුරකථන', 'icon': 'wifi', 'color': 0xFF00897B},
      {'name_en': 'Food', 'name_si': 'ආහාර', 'icon': 'food', 'color': 0xFFE53935},
      {'name_en': 'Transport', 'name_si': 'ප්‍රවාහන', 'icon': 'bus', 'color': 0xFF3949AB},
      {'name_en': 'Other', 'name_si': 'වෙනත්', 'icon': 'more', 'color': 0xFF757575},
    ];
    final batch = db.batch();
    for (final c in cats) {
      batch.insert('categories', c);
    }
    await batch.commit(noResult: true);
  }

    Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE bills ADD COLUMN anchor_day INTEGER NOT NULL DEFAULT 1');
      // Existing bills: anchor day = day of their current due date
      await db.execute(
          "UPDATE bills SET anchor_day = CAST(strftime('%d', due_date) AS INTEGER)");
    }
  }
}