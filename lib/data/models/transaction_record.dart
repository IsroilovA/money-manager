import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:uuid/uuid.dart';
part 'transaction_record.g.dart';

const uuid = Uuid();

final formatter = DateFormat.yMd();
final currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$');

enum ExpenseCategory { food, travel, shopping, leisure }

enum IncomeCategory {
  salary,
  gift,
  investment,
  freelance,
}

enum RecordType {
  income,
  expense,
  transfer,
}

const categoryIcons = {
  ExpenseCategory.food: Icons.lunch_dining,
  ExpenseCategory.travel: Icons.flight_takeoff,
  ExpenseCategory.leisure: Icons.movie,
  ExpenseCategory.shopping: Icons.shopping_cart_outlined,
  IncomeCategory.salary: Icons.work_outline,
  IncomeCategory.gift: Icons.card_giftcard,
  IncomeCategory.investment: Icons.auto_graph,
  IncomeCategory.freelance: Icons.laptop_chromebook,
};

@JsonSerializable()
class TransactionRecord {
  TransactionRecord({
    this.note,
    required this.date,
    required this.amount,
    required this.recordType,
    // required this.account,
    this.expenseCategory,
    this.incomeCategory,
  }) : id = uuid.v4();

  // final Account account;
  final String id;
  final DateTime date;
  final double amount;
  final String? note;
  final RecordType recordType;
  final ExpenseCategory? expenseCategory;
  final IncomeCategory? incomeCategory;

  String get formattedDate {
    return formatter.format(date);
  }

  String get formattedAmount {
    return currencyFormatter.format(amount);
  }

  factory TransactionRecord.fromJson(Map<String, dynamic> json) =>
      _$TransactionRecordFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRecordToJson(this);
}
