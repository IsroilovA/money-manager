import 'package:intl/intl.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/database_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

final currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$');
const uuid = Uuid();

@JsonSerializable()
class Account {
  final String name;
  final double balance;
  final String id;
  Account({
    required this.name,
    required this.balance,
    id,
  }) : id = id ?? uuid.v4();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Future<String> get formattedIncomeLast30Days async {
    Future<List<TransactionRecord>?> records =
        DatabaseHelper.getAccountTransactionRecords(this.id);
    double income = 0.0;
    return records.then(
      (records) {
        final DateTime today = DateTime.now();
        final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
        if (records == null) {
          return currencyFormatter.format(0);
        } else {
          for (var record in records) {
            if (record.date.isAfter(thirtyDaysAgo)) {
              if (record.recordType == RecordType.income) {
                income += record.amount;
              }
            }
          }
          return currencyFormatter.format(income);
        }
      },
    );
  }

  Future<String> get formattedExpenseLast30Days {
    Future<List<TransactionRecord>?> records =
        DatabaseHelper.getAccountTransactionRecords(this.id);
    double expense = 0.0;
    return records.then(
      (records) {
        final DateTime today = DateTime.now();
        final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
        if (records == null) {
          return currencyFormatter.format(0);
        } else {
          for (var record in records) {
            if (record.date.isAfter(thirtyDaysAgo)) {
              if (record.recordType == RecordType.expense) {
                expense += record.amount;
              }
            }
          }
          return currencyFormatter.format(expense);
        }
      },
    );
  }
}
