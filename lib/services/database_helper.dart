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
            "CREATE TABLE transactions(id TEXT PRIMARY KEY, date INT, amount REAL, transferAccount2Id TEXT, accountId TEXT, note TEXT, recordType TEXT, incomeCategory TEXT, expenseCategory TEXT)");
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
      TransactionRecord newRecord) async {
    final db = await _openDB();
    final account = await getAccountById(newRecord.accountId);
    final newBalance;
    if (newRecord.recordType == RecordType.income) {
      newBalance = account.balance + newRecord.amount;
    } else {
      newBalance = account.balance - newRecord.amount;
    }

    await db.update("accounts", {'balance': newBalance},
        where: 'id = ?', whereArgs: [account.id]);
  }

  static Future<void> _updateAccountBalanceDelete(
      TransactionRecord deletedRecord) async {
    final db = await _openDB();

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
    } else {
      final account = await getAccountById(deletedRecord.accountId);
      final newBalance;
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
    await _updateAccountBalanceAdd(transactionRecord);
  }

  static Future<void> deleteTransationRecord(
      TransactionRecord transactionRecord) async {
    final db = await _openDB();

    await db.delete("transactions",
        where: 'id = ?', whereArgs: [transactionRecord.id]);
    await _updateAccountBalanceDelete(transactionRecord);
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
}
