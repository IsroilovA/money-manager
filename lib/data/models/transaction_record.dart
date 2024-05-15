import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:money_manager/services/helper_fucntion.dart';
import 'package:uuid/uuid.dart';
part 'transaction_record.g.dart';

const uuid = Uuid();

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

const categoryColors = {
  ExpenseCategory.food: Colors.red,
  ExpenseCategory.leisure: Colors.blue,
  ExpenseCategory.shopping: Colors.green,
  ExpenseCategory.travel: Colors.orange,
  IncomeCategory.salary: Colors.purple,
  IncomeCategory.gift: Colors.pink,
  IncomeCategory.investment: Colors.deepPurple,
  IncomeCategory.freelance: Colors.amber,
};

const categoryIcons = {
  ExpenseCategory.food: Icons.lunch_dining,
  ExpenseCategory.travel: Icons.flight_takeoff,
  ExpenseCategory.leisure: Icons.movie,
  ExpenseCategory.shopping: Icons.shopping_cart,
  IncomeCategory.salary: Icons.work,
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
    required this.accountId,
    this.transferAccount2Id,
    this.expenseCategory,
    this.incomeCategory,
    id,
  }) : id = id ?? uuid.v4();

  final String? transferAccount2Id;
  final String accountId;
  final String id;
  final DateTime date;
  final double amount;
  final String? note;
  final RecordType recordType;
  final ExpenseCategory? expenseCategory;
  final IncomeCategory? incomeCategory;

  String get formattedDate {
    return dateFormatter.format(date);
  }

  String get formattedAmount {
    return currencyFormatter.format(amount);
  }

  factory TransactionRecord.fromJson(Map<String, dynamic> json) =>
      _$TransactionRecordFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionRecordToJson(this);
}
