import 'package:sqflite/sqflite.dart';
import 'database_helper.dart' as dbHelper;
import 'transaction.dart' as app_transaction;

class TransactionRepository {
  final dbHelper.DatabaseHelper _dbHelper = dbHelper.DatabaseHelper();

  Future<void> insertTransaction(app_transaction.Transaction transaction) async {
    final Database db = await _dbHelper.database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<List<app_transaction.Transaction>> getTransactions() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (i) {
      return app_transaction.Transaction(
        id: maps[i]['id'],
        name: maps[i]['name'],
        amount: maps[i]['amount'],
      );
    });
  }

  Future<void> clearTransactions() async {
    final Database db = await _dbHelper.database;
    await db.delete('transactions');
  }
}
