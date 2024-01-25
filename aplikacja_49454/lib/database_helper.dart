import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance.db');
    return await openDatabase(path, version: 1, onCreate: createTables);
  }

  Future<void> createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS budget(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount REAL
      )
    ''');
  }

  Future<void> setBudget(double amount) async {
    final Database db = await database;
    await db.insert('budget', {'amount': amount}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<double> getCurrentBudget() async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query('budget');
    return result.isNotEmpty ? result.first['amount'] as double : 0.0;
  }

  Future<void> insertExpense(String name, double amount) async {
    final Database db = await database;
    await db.insert('expenses', {'name': name, 'amount': amount});
    await updateBudget(amount);
  }

  Future<void> updateBudget(double expenseAmount) async {
    final Database db = await database;
    double currentBudget = await getCurrentBudget();
    double updatedBudget = currentBudget - expenseAmount;
    await db.update('budget', {'amount': updatedBudget});
  }

  Future<void> clearBudget() async {
    final Database db = await database;
    await db.delete('budget');
  }

  Future<void> clearExpenses() async {
    final Database db = await database;
    await db.delete('expenses');
  }
}
