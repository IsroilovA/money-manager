import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "MoneyManager.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        return await db.execute(
            "CREATE TABLE  account(id TEXT PRIMARY KEY, name TEXT, balance REAL)");
      },
      version: _version,
    );
  }
}
