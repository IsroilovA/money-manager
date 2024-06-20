import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final GetIt locator = GetIt.instance;

Future<void> initialiseLocator() async {
  //key
  const int _version = 1;
  const String _dbName = "MoneyManager.db";

  //database
  final db = await openDatabase(
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

  // // const currenciesKey = 'currencies';
  // // const currenciesPinnedKey = 'currenciesPinned';

  // //box
  // final currenciesBox = await Hive.openBox<CurrencyRate?>(currenciesKey);
  // final currenciesPinnedBox =
  //     await Hive.openBox<CurrencyPinned?>(currenciesPinnedKey);
  //locator
  locator.registerSingleton(
    CurrenciesRepository(
        currenciesBox: currenciesBox, currenciesPinnedBox: currenciesPinnedBox),
  );
}
