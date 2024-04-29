import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';

Account cash = Account(name: 'cash', balance: 20000, records: dummyRecords);

List<TransactionRecord> dummyRecords = [
  TransactionRecord(
    note: "Groceries",
    date: DateTime(2024, 4, 1),
    amount: 50.0,
    recordType: RecordType.expense,
    expenseCategory: ExpenseCategory.food,
  ),
  TransactionRecord(
    note: "Gasoline",
    date: DateTime(2024, 4, 2),
    amount: 40.0,
    recordType: RecordType.expense,
    expenseCategory: ExpenseCategory.travel,
  ),
  TransactionRecord(
    note: "Clothing",
    date: DateTime(2024, 4, 3),
    amount: 100.0,
    recordType: RecordType.expense,
    expenseCategory: ExpenseCategory.shopping,
  ),
  TransactionRecord(
    note: "Movie Tickets",
    date: DateTime(2024, 4, 4),
    amount: 25.0,
    recordType: RecordType.expense,
    expenseCategory: ExpenseCategory.leisure,
  ),
  TransactionRecord(
    note: "Freelance Work",
    date: DateTime(2024, 4, 5),
    amount: 200.0,
    recordType: RecordType.income,
    incomeCategory: IncomeCategory.freelance,
  ),
  TransactionRecord(
    note: "Monthly Salary",
    date: DateTime(2024, 4, 7),
    amount: 3000.0,
    recordType: RecordType.income,
    incomeCategory: IncomeCategory.salary,
  ),
  TransactionRecord(
    note: "Birthday Gift",
    date: DateTime(2024, 4, 8),
    amount: 50.0,
    recordType: RecordType.income,
    incomeCategory: IncomeCategory.gift,
  ),
  TransactionRecord(
    note: "Dividend Income",
    date: DateTime(2024, 4, 9),
    amount: 150.0,
    recordType: RecordType.income,
    incomeCategory: IncomeCategory.investment,
  ),
  TransactionRecord(
    note: "Freelance Project",
    date: DateTime(2024, 4, 10),
    amount: 400.0,
    recordType: RecordType.income,
    incomeCategory: IncomeCategory.freelance,
  ),
  // Add more dummy records as needed...
];
