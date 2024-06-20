import 'package:flutter/material.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/statistics/cubit/statistics_cubit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class MoneyManagerRepository {
  MoneyManagerRepository({required Database moneyManagerDb})
      : _moneyManagerDb = moneyManagerDb;

  //database
  final Database _moneyManagerDb;

  // Retrieve all goals from the database
  Future<List<Goal>?> getAllGoals() async {
    final List<Map<String, dynamic>> maps =
        await _moneyManagerDb.query("goals");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => Goal.fromJson(maps[index]),
    );
  }

  // Retrieve a specific goal by its ID
  Future<Goal> getGoalById(String id) async {
    final List<Map<String, dynamic>> maps = await _moneyManagerDb.query("goals",
        where: 'id = ?', whereArgs: [id], limit: 1);

    return Goal.fromJson(maps.first);
  }

  // Add a saved amount to a specific goal
  Future<void> addGoalSavedAmount(
      Goal goal, double adde_moneyManagerDbalance) async {
    var newCurrentBalance = goal.currentBalance + adde_moneyManagerDbalance;

    await _moneyManagerDb.update("goals", {'currentBalance': newCurrentBalance},
        where: 'id = ?', whereArgs: [goal.id]);
  }

  // Insert a new goal into the database
  Future<void> addGoal(Goal goal) async {
    await _moneyManagerDb.insert("goals", goal.toJson());
  }

  // Update an existing goal in the database
  Future<void> editGoal(Goal goal) async {
    await _moneyManagerDb
        .update("goals", goal.toJson(), where: 'id = ?', whereArgs: [goal.id]);
  }

  // Delete a goal from the database
  Future<void> deleteGoal(Goal goal) async {
    await _moneyManagerDb
        .delete("goals", where: 'id = ?', whereArgs: [goal.id]);
  }

  // Retrieve all accounts from the database
  Future<List<Account>?> getAllAccounts() async {
    final List<Map<String, dynamic>> maps =
        await _moneyManagerDb.query("accounts");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => Account.fromJson(maps[index]),
    );
  }

  // Check if there are any accounts in the database
  Future<bool> hasAccounts() async {
    List<Map<String, dynamic>> maps =
        await _moneyManagerDb.query("accounts", limit: 1);
    return maps.isNotEmpty;
  }

  // Calculate the total balance of all accounts
  Future<double> getTotalBalance() async {
    List<Map<String, dynamic>> result = await _moneyManagerDb
        .rawQuery('SELECT SUM(balance) AS totalBalance FROM accounts');
    double totalBalance = result[0]['totalBalance'] ?? 0.0;
    return totalBalance;
  }

  // Insert a new account into the database
  Future<void> addAccount(Account account) async {
    await _moneyManagerDb.insert("accounts", account.toJson());
  }

  // Update an existing account and create a balance adjustment record
  Future<void> editAccount(Account account, double previousBalance) async {
    final record = TransactionRecord(
        date: DateTime.now(),
        amount: account.balance - previousBalance,
        recordType: RecordType.balanceAdjustment,
        accountId: account.id);

    var batch = _moneyManagerDb.batch();
    batch.insert("transactions", record.toJson());
    batch.update("accounts", account.toJson(),
        where: 'id = ?', whereArgs: [account.id]);
    await batch.commit();
  }

  // Delete an account and its related transactions from the database
  Future<void> deleteAccount(Account account) async {
    var batch = _moneyManagerDb.batch();

    batch.delete("accounts", where: 'id = ?', whereArgs: [account.id]);
    batch.delete("transactions",
        where: 'accountId = ? OR transferAccount2Id = ?',
        whereArgs: [account.id, account.id]);
    await batch.commit();
  }

  // Insert a transfer transaction and update account balances
  Future<void> addTransferTransaction(TransactionRecord newRecord) async {
    final accountSender = await getAccountById(newRecord.accountId);
    final accountReceiver = await getAccountById(newRecord.transferAccount2Id!);

    final newBalanceSender = accountSender.balance - newRecord.amount;
    final newBalanceReceiver = accountReceiver.balance + newRecord.amount;

    var batch = _moneyManagerDb.batch();
    batch.insert("transactions", newRecord.toJson());
    batch.update("accounts", {'balance': newBalanceSender},
        where: 'id = ?', whereArgs: [accountSender.id]);
    batch.update("accounts", {'balance': newBalanceReceiver},
        where: 'id = ?', whereArgs: [accountReceiver.id]);
    await batch.commit();
  }

  // Helper method to update account balance when adding a transaction
  Future<void> _updateAccountBalanceAdd(
      Database _moneyManagerDb, TransactionRecord newRecord) async {
    final account = await getAccountById(newRecord.accountId);
    double newBalance;
    if (newRecord.recordType == RecordType.income) {
      newBalance = account.balance + newRecord.amount;
    } else if (newRecord.recordType == RecordType.balanceAdjustment) {
      newBalance = account.balance + newRecord.amount;
    } else {
      newBalance = account.balance - newRecord.amount;
    }

    await _moneyManagerDb.update("accounts", {'balance': newBalance},
        where: 'id = ?', whereArgs: [account.id]);
  }

  // Helper method to update account balance when deleting a transaction
  Future<void> _updateAccountBalanceDelete(
      Database _moneyManagerDb, TransactionRecord deletedRecord) async {
    if (deletedRecord.recordType == RecordType.transfer) {
      final accountSender = await getAccountById(deletedRecord.accountId);
      final accountReceiver =
          await getAccountById(deletedRecord.transferAccount2Id!);
      final newBalanceSender = accountSender.balance + deletedRecord.amount;
      final newBalanceReceiver = accountReceiver.balance - deletedRecord.amount;
      var batch = _moneyManagerDb.batch();
      batch.update("accounts", {'balance': newBalanceSender},
          where: 'id = ?', whereArgs: [accountSender.id]);
      batch.update("accounts", {'balance': newBalanceReceiver},
          where: 'id = ?', whereArgs: [accountReceiver.id]);
      await batch.commit();
    } else if (deletedRecord.recordType == RecordType.balanceAdjustment) {
      final account = await getAccountById(deletedRecord.accountId);
      double newBalance;
      if (deletedRecord.amount >= 0) {
        newBalance = account.balance - deletedRecord.amount;
      } else {
        newBalance = account.balance - deletedRecord.amount;
      }
      await _moneyManagerDb.update("accounts", {'balance': newBalance},
          where: 'id = ?', whereArgs: [account.id]);
    } else {
      final account = await getAccountById(deletedRecord.accountId);
      double newBalance;
      if (deletedRecord.recordType == RecordType.income) {
        newBalance = account.balance - deletedRecord.amount;
      } else {
        newBalance = account.balance + deletedRecord.amount;
      }
      await _moneyManagerDb.update("accounts", {'balance': newBalance},
          where: 'id = ?', whereArgs: [account.id]);
    }
  }

  // Retrieve a specific account by its ID
  Future<Account> getAccountById(String id) async {
    final List<Map<String, dynamic>> maps = await _moneyManagerDb
        .query("accounts", where: 'id = ?', whereArgs: [id], limit: 1);

    return Account.fromJson(maps.first);
  }

  // Insert a new transaction record and update account balance
  Future<void> addTransactionRecord(TransactionRecord transactionRecord) async {
    await _moneyManagerDb.insert("transactions", transactionRecord.toJson());
    await _updateAccountBalanceAdd(_moneyManagerDb, transactionRecord);
  }

  // Delete a transaction record and update account balance
  Future<void> deleteTransactionRecord(
      TransactionRecord transactionRecord) async {
    await _moneyManagerDb.delete("transactions",
        where: 'id = ?', whereArgs: [transactionRecord.id]);
    await _updateAccountBalanceDelete(_moneyManagerDb, transactionRecord);
  }

  // Retrieve all transaction records for a specific account
  Future<List<TransactionRecord>?> getAccountTransactionRecords(
      String accountId) async {
    final List<Map<String, dynamic>> maps = await _moneyManagerDb.query(
        "transactions",
        where: 'accountId = ? OR transferAccount2Id = ?',
        whereArgs: [accountId, accountId],
        orderBy: 'date DESC');

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => TransactionRecord.fromJson(maps[index]),
    );
  }

  // Retrieve all transaction records from the database
  Future<List<TransactionRecord>?> getAllTransactionRecords() async {
    final List<Map<String, dynamic>> maps =
        await _moneyManagerDb.query("transactions", orderBy: 'date DESC');

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => TransactionRecord.fromJson(maps[index]),
    );
  }

  // Retrieve transaction records filtered by record type
  Future<List<TransactionRecord>?> getTransactionRecordsByRecordType(
      RecordType recordType) async {
    final List<Map<String, dynamic>> maps = await _moneyManagerDb.query(
        "transactions",
        where: 'recordType = ?',
        orderBy: 'date DESC',
        whereArgs: [recordType.name]);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
      maps.length,
      (index) => TransactionRecord.fromJson(maps[index]),
    );
  }

  // Calculate the total amount for a specific record type within the last 30 days
  Future<Map<RecordType, double>> getTotalIncomeExpenseAmount() async {
    int thirtyDaysAgoTimeStamp = DateTime.now()
        .subtract(const Duration(days: 30))
        .millisecondsSinceEpoch;

    // List<Map<String, dynamic>> result = await _moneyManagerDb.rawQuery(
    //     'SELECT SUM(amount) AS totalAmount FROM transactions WHERE recordType = ? AND date >= ?',
    //     [recordType.name, thirtyDaysAgoTimeStamp]);

    var batch = _moneyManagerDb.batch();
    batch.rawQuery(
        'SELECT SUM(amount) AS incomeAmount FROM transactions WHERE recordType = ? AND date >= ?',
        [RecordType.income.name, thirtyDaysAgoTimeStamp]);
    batch.rawQuery(
        'SELECT SUM(amount) AS expenseAmount FROM transactions WHERE recordType = ? AND date >= ?',
        [RecordType.expense.name, thirtyDaysAgoTimeStamp]);

    dynamic result = await batch.commit();
    double incomeAmount = result[0][0]['incomeAmount'] ?? 0.0;
    double expenseAmount = result[1][0]['expenseAmount'] ?? 0.0;

    return {RecordType.income: incomeAmount, RecordType.expense: expenseAmount};
  }

  // Retrieve total amount by categories for a given date range and record type
  Future<List<PieChartData>> getTotalAmountByCategories(
      DateTimeRange dateTimeRange, RecordType recordType) async {
    String categoryColumn =
        recordType == RecordType.expense ? 'expenseCategory' : 'incomeCategory';

    const now = Duration(hours: 24);

    List<Map<String, dynamic>> maps = await _moneyManagerDb.rawQuery(
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

  // Retrieve total amount by date for a given date range and record type
  Future<List<LineChartData>> getTotalAmountByDate(
      DateTimeRange dateTimeRange, RecordType recordType) async {
    const now = Duration(hours: 24);

    List<Map<String, dynamic>> maps = await _moneyManagerDb.rawQuery(
      'SELECT date, SUM(amount) AS totalAmount FROM transactions WHERE recordType = ? AND date BETWEEN ? AND ? GROUP BY STRFTIME("%Y-%m-%d", date/1000, "unixepoch") ORDER BY STRFTIME("%Y-%m-%d", date/1000, "unixepoch") ASC',
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
