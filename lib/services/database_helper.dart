import 'package:flutter/material.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/statistics/cubit/statistics_cubit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "MoneyManager.db";

  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        var batch = db.batch();
        batch.execute(
            "CREATE TABLE accounts(id TEXT PRIMARY KEY, name TEXT, balance REAL)");
        batch.execute(
            "CREATE TABLE transactions(id TEXT PRIMARY KEY, date INT, amount REAL, transferAccount2Id TEXT, accountId TEXT, note TEXT, recordType TEXT, incomeCategory TEXT, expenseCategory TEXT)");
        batch.execute(
            "CREATE TABLE goals(id TEXT PRIMARY KEY, name TEXT, currentBalance REAL, goalBalance REAL)");
        await batch.commit();
      },
      version: _version,
    );
  }

  static Future<List<Goal>?> getAllGoals() async {
    final db = await _openDB();

    final List<Map<String, dynamic>> maps = await db.query("goals");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => Goal.fromJson(maps[index]),
    );
  }

  static Future<Goal> getGoalById(String id) async {
    final db = await _openDB();

    final List<Map<String, dynamic>> maps =
        await db.query("goals", where: 'id = ?', whereArgs: [id], limit: 1);

    return Goal.fromJson(maps.first);
  }

  static Future<void> addGoalSavedAmount(Goal goal, double addedBalance) async {
    final db = await _openDB();

    var newCurrentBalance = goal.currentBalance + addedBalance;

    await db.update("goals", {'currentBalance': newCurrentBalance},
        where: 'id = ?', whereArgs: [goal.id]);
  }

  static Future<void> addGoal(Goal goal) async {
    final db = await _openDB();

    await db.insert("goals", goal.toJson());
  }

  static Future<void> editGoal(Goal goal) async {
    final db = await _openDB();

    await db
        .update("goals", goal.toJson(), where: 'id = ?', whereArgs: [goal.id]);
  }

  static Future<void> deleteGoal(Goal goal) async {
    final db = await _openDB();

    await db.delete("goals", where: 'id = ?', whereArgs: [goal.id]);
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

  static Future<bool> hasAccounts() async {
    final db = await _openDB();
    // Execute a query to check if there are any rows in the table
    List<Map<String, dynamic>> maps = await db.query("accounts", limit: 1);

    // If the result contains any rows, return true; otherwise, return false
    return maps.isNotEmpty;
  }

  static Future<double> getTotalBalance() async {
    final db = await _openDB();
    // Execute SQL query to calculate the total balance
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT SUM(balance) AS totalBalance FROM accounts');

    // Extract and return the total balance
    double totalBalance = result[0]['totalBalance'] ?? 0.0;
    return totalBalance;
  }

  static Future<void> addAccount(Account account) async {
    final db = await _openDB();

    await db.insert("accounts", account.toJson());
  }

  static Future<void> editAccount(
      Account account, double previousBalance) async {
    final db = await _openDB();

    //create balance adjustment record
    final record = TransactionRecord(
        date: DateTime.now(),
        amount: account.balance - previousBalance,
        recordType: RecordType.balanceAdjustment,
        accountId: account.id);

    var batch = db.batch();
    batch.insert("transactions", record.toJson());
    batch.update("accounts", account.toJson(),
        where: 'id = ?', whereArgs: [account.id]);
    await batch.commit();
  }

  static Future<void> deleteAccount(Account account) async {
    final db = await _openDB();
    var batch = db.batch();

    batch.delete("accounts", where: 'id = ?', whereArgs: [account.id]);
    batch.delete("transactions",
        where: 'accountId = ? OR transferAccount2Id = ?',
        whereArgs: [account.id, account.id]);
    await batch.commit();
  }

  static Future<void> addTransferTransaction(
      TransactionRecord newRecord) async {
    final db = await _openDB();
    final accountSender = await getAccountById(newRecord.accountId);
    final accountReceiver = await getAccountById(newRecord.transferAccount2Id!);

    final newBalanceSender = accountSender.balance - newRecord.amount;
    final newBalanceReceiver = accountReceiver.balance + newRecord.amount;

    var batch = db.batch();
    batch.insert("transactions", newRecord.toJson());
    batch.update("accounts", {'balance': newBalanceSender},
        where: 'id = ?', whereArgs: [accountSender.id]);
    batch.update("accounts", {'balance': newBalanceReceiver},
        where: 'id = ?', whereArgs: [accountReceiver.id]);
    await batch.commit();
  }

  static Future<void> _updateAccountBalanceAdd(
      Database db, TransactionRecord newRecord) async {
    final account = await getAccountById(newRecord.accountId);
    double newBalance;
    if (newRecord.recordType == RecordType.income) {
      newBalance = account.balance + newRecord.amount;
    } else {
      newBalance = account.balance - newRecord.amount;
    }

    await db.update("accounts", {'balance': newBalance},
        where: 'id = ?', whereArgs: [account.id]);
  }

  static Future<void> _updateAccountBalanceDelete(
      Database db, TransactionRecord deletedRecord) async {
    if (deletedRecord.recordType == RecordType.transfer) {
      final accountSender = await getAccountById(deletedRecord.accountId);
      final accountReceiver =
          await getAccountById(deletedRecord.transferAccount2Id!);
      final newBalanceSender = accountSender.balance + deletedRecord.amount;
      final newBalanceReceiver = accountReceiver.balance - deletedRecord.amount;
      var batch = db.batch();
      batch.update("accounts", {'balance': newBalanceSender},
          where: 'id = ?', whereArgs: [accountSender.id]);
      batch.update("accounts", {'balance': newBalanceReceiver},
          where: 'id = ?', whereArgs: [accountReceiver.id]);
      await batch.commit();
    } else if (deletedRecord.recordType == RecordType.balanceAdjustment) {
      final account = await getAccountById(deletedRecord.accountId);
      double newBalance = account.balance - deletedRecord.amount;
      await db.update("accounts", {'balance': newBalance},
          where: 'id = ?', whereArgs: [account.id]);
    } else {
      final account = await getAccountById(deletedRecord.accountId);
      double newBalance;
      if (deletedRecord.recordType == RecordType.income) {
        newBalance = account.balance - deletedRecord.amount;
      } else {
        newBalance = account.balance + deletedRecord.amount;
      }
      await db.update("accounts", {'balance': newBalance},
          where: 'id = ?', whereArgs: [account.id]);
    }
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
    await _updateAccountBalanceAdd(db, transactionRecord);
  }

  static Future<void> deleteTransationRecord(
      TransactionRecord transactionRecord) async {
    final db = await _openDB();

    await db.delete("transactions",
        where: 'id = ?', whereArgs: [transactionRecord.id]);
    await _updateAccountBalanceDelete(db, transactionRecord);
  }

  static Future<List<TransactionRecord>?> getAccountTransactionRecords(
      String accountId) async {
    final db = await _openDB();

    final List<Map<String, dynamic>> maps = await db.query("transactions",
        where: 'accountId = ?', whereArgs: [accountId], orderBy: 'date DESC');

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

    final List<Map<String, dynamic>> maps =
        await db.query("transactions", orderBy: 'date DESC');

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => TransactionRecord.fromJson(maps[index]),
    );
  }

  static Future<double> getTotalAmountByRecordType(
      RecordType recordType) async {
    final db = await _openDB();

    int thirtyDaysAgoTimeStamp = DateTime.now()
        .subtract(const Duration(days: 30))
        .millisecondsSinceEpoch;

    // Execute SQL query to calculate the total amount based on recordType
    List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT SUM(amount) AS totalAmount FROM transactions WHERE recordType = ? AND date >= ?',
        [recordType.name, thirtyDaysAgoTimeStamp]);

    // Extract and return the total amount
    double totalAmount = result[0]['totalAmount'] ?? 0.0;
    return totalAmount;
  }

  static Future<List<PieChartData>> getTotalAmountByCategories(
      DateTimeRange dateTimeRange, RecordType recordType) async {
    final db = await _openDB();
    // Define the column name based on the recordType
    String categoryColumn =
        recordType == RecordType.expense ? 'expenseCategory' : 'incomeCategory';

    const now = Duration(hours: 24);

    // Execute SQL query to calculate the total amount grouped by category
    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT $categoryColumn, SUM(amount) AS totalAmount FROM transactions WHERE recordType = ? AND date BETWEEN ? AND ? GROUP BY $categoryColumn',
      [
        recordType.name,
        dateTimeRange.start.millisecondsSinceEpoch,
        dateTimeRange.end.millisecondsSinceEpoch + now.inMilliseconds,
      ],
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(
      maps.length,
      (index) => PieChartData(
        maps[index][categoryColumn],
        maps[index]['totalAmount'].toDouble(),
      ),
    );
  }

  static Future<List<LineChartData>> getTotalAmountByDate(
      DateTimeRange dateTimeRange, RecordType recordType) async {
    final db = await _openDB();

    const now = Duration(hours: 24);

    List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT date, SUM(amount) AS totalAmount FROM transactions WHERE recordType = ? AND date BETWEEN ? AND ? GROUP BY STRFTIME("%Y-%m-%d", date/1000, "unixepoch")',
      [
        recordType.name,
        dateTimeRange.start.millisecondsSinceEpoch,
        dateTimeRange.end.millisecondsSinceEpoch + now.inMilliseconds,
      ],
    );

    return List.generate(
        maps.length,
        (index) => LineChartData(
            DateTime.fromMillisecondsSinceEpoch(maps[index]['date'] as int),
            maps[index]['totalAmount'].toDouble()));
  }
}
