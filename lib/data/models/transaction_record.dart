import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:money_manager/services/helper_fucntions.dart';
import 'package:uuid/uuid.dart';
part 'transaction_record.g.dart';

const uuid = Uuid();

enum ExpenseCategory { food, travel, shopping, leisure, savings }

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
  balanceAdjustment,
}

const categoryColors = {
  ExpenseCategory.food: Color.fromRGBO(255, 82, 82, 1),
  ExpenseCategory.savings: Color.fromARGB(255, 162, 136, 127),
  ExpenseCategory.leisure: Color.fromRGBO(64, 196, 255, 1),
  ExpenseCategory.shopping: Color.fromRGBO(178, 255, 89, 1),
  ExpenseCategory.travel: Color.fromRGBO(255, 171, 64, 1),
  IncomeCategory.salary: Color.fromARGB(255, 179, 135, 255),
  IncomeCategory.gift: Color.fromARGB(255, 252, 126, 168),
  IncomeCategory.investment: Color.fromRGBO(124, 77, 255, 1),
  IncomeCategory.freelance: Color.fromRGBO(255, 215, 64, 1),
};

const categoryIcons = {
  ExpenseCategory.food: Icons.lunch_dining,
  ExpenseCategory.travel: Icons.flight_takeoff,
  ExpenseCategory.leisure: Icons.movie,
  ExpenseCategory.shopping: Icons.shopping_cart,
  ExpenseCategory.savings: Icons.savings,
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
