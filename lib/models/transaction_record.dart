import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/widgets/balance_card.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final formatter = DateFormat.yMd();
final currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$');

enum ExpenseCategory {
  food,
  travel,
  shopping,
  leisure
}

enum IncomeCategory {
  salary,
  gift,
  investment,
  freelance,
}

enum RecordType {
  income,
  expense,
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

class TransactionRecord {
  TransactionRecord({
    required this.title,
    required this.date,
    required this.amount,
    required this.recordType,
    this.expenseCategory,
    this.incomeCategory,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final DateTime date;
  final double amount;
  final RecordType recordType;
  final ExpenseCategory? expenseCategory;
  final IncomeCategory? incomeCategory;

  String get formattedDate {
    return formatter.format(date);
  }

  String get formattedAmount {
    return currencyFormatter.format(amount);
  }
}
