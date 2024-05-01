import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "MoneyManager.db";

  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE accounts(id TEXT PRIMARY KEY, name TEXT, balance REAL)");
        await db.execute(
            "CREATE TABLE transactions(id TEXT PRIMARY KEY, date TEXT, amount REAL, account TEXT, note TEXT, recordType TEXT, incomeCategory TEXT, expenseCategory TEXT)");
      },
      version: _version,
    );
  }

  static Future<List<Account>?> getAllAccounts() async {
    final db = await _openDB();

    final List<Map<String, dynamic>> maps = await db.query("accounts");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => Account.fromJson(maps[index]),
    );
  }

  static Future<void> addAccount(Account account) async {
    final db = await _openDB();

    await db.insert("accounts", account.toJson());
  }

  static Future<Account> getAccountById(String id) async {
    final db = await _openDB();

    final List<Map<String, dynamic>> maps =
        await db.query("accounts", where: 'id = ?', whereArgs: [id], limit: 1);

    return Account.fromJson(maps.first);
  }

  static Future<void> addTransationRecord(
      TransactionRecord transactionRecord) async {
    final db = await _openDB();

    await db.insert("transactions", transactionRecord.toJson());
  }

  static Future<List<TransactionRecord>?> getAccountTransactionRecords(
      String AccountId) async {
    final db = await _openDB();

    final List<Map<String, dynamic>> maps = await db
        .query("transactions", where: 'accountId = ?', whereArgs: [AccountId]);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => TransactionRecord.fromJson(maps[index]),
    );
  }

  static Future<List<TransactionRecord>?> getAllTransactionRecords() async {
    final db = await _openDB();

    final List<Map<String, dynamic>> maps = await db.query("transactions");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => TransactionRecord.fromJson(maps[index]),
    );
  }
}
