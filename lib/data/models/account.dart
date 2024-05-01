import 'package:intl/intl.dart';
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
  // {
  //   final DateTime today = DateTime.now();
  //   final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
  //   for (var record in records) {
  //     if (record.date.isAfter(thirtyDaysAgo)) {
  //       if (record.recordType == RecordType.income) {
  //         income += record.amount;
  //       } else {
  //         expense += record.amount;
  //       }
  //     }
  //   }
  // }

//   String get formattedIncomeLast30Days {
//     double income = 0.0;
//     final DateTime today = DateTime.now();
//     final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
//     for (var record in records) {
//       if (record.date.isAfter(thirtyDaysAgo)) {
//         if (record.recordType == RecordType.income) {
//           income += record.amount;
//         }
//       }
//     }
//     return currencyFormatter.format(income);
//   }

//   String get formattedExpenseLast30Days {
//     double expense = 0.0;
//     final DateTime today = DateTime.now();
//     final DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
//     for (var record in records) {
//       if (record.date.isAfter(thirtyDaysAgo)) {
//         if (record.recordType == RecordType.expense) {
//           expense += record.amount;
//         }
//       }
//     }
//     return currencyFormatter.format(expense);
//   }
}
