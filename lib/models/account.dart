import 'package:intl/intl.dart';
import 'package:money_manager/models/transaction_record.dart';
import 'package:uuid/uuid.dart';

final currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$');
const uuid = Uuid();

class Account {
  final String name;
  final double balance;
  final List<TransactionRecord> records;
  double income = 0.0;
  double expense = 0.0;
  final String id;
  Account({
    required this.name,
    required this.balance,
    required this.records,
  }) : id = uuid.v4() {
    final DateTime today = DateTime.now();
    final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
    for (var record in records) {
      if (record.date.isAfter(thirtyDaysAgo)) {
        if (record.recordType == RecordType.income) {
          income += record.amount;
        } else {
          expense += record.amount;
        }
      }
    }
  }

  // String get formattedIncomeLast30Days {
  //   double income = 0.0;
  //   final DateTime today = DateTime.now();
  //   final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
  //   for (var record in records) {
  //     if (record.date.isAfter(thirtyDaysAgo)) {
  //       if (record.recordType == RecordType.income) {
  //         income += record.amount;
  //       }
  //     }
  //   }
  //   return currencyFormatter.format(income);
  // }

  // String get formattedExpenseLast30Days {
  //   double expense = 0.0;
  //   final DateTime today = DateTime.now();
  //   final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
  //   for (var record in records) {
  //     if (record.date.isAfter(thirtyDaysAgo)) {
  //       if (record.recordType == RecordType.expense) {
  //         expense += record.amount;
  //       }
  //     }
  //   }
  //   return currencyFormatter.format(expense);
  // }
}
