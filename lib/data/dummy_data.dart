import 'package:money_manager/models/account.dart';
import 'package:money_manager/models/transaction_record.dart';


Account dummyAccount = Account(name: 'Alisher', balance: 20000, records: dummyRecords);


List<TransactionRecord> dummyRecords = [
    TransactionRecord(
      title: "Groceries",
      date: DateTime(2024, 4, 1),
      amount: 50.0,
      recordType: RecordType.expense,
      expenseCategory: ExpenseCategory.food,
    ),
    TransactionRecord(
      title: "Gasoline",
      date: DateTime(2024, 4, 2),
      amount: 40.0,
      recordType: RecordType.expense,
      expenseCategory: ExpenseCategory.travel,
    ),
    TransactionRecord(
      title: "Clothing",
      date: DateTime(2024, 4, 3),
      amount: 100.0,
      recordType: RecordType.expense,
      expenseCategory: ExpenseCategory.shopping,
    ),
    TransactionRecord(
      title: "Movie Tickets",
      date: DateTime(2024, 4, 4),
      amount: 25.0,
      recordType: RecordType.expense,
      expenseCategory: ExpenseCategory.leisure,
    ),
    TransactionRecord(
      title: "Freelance Work",
      date: DateTime(2024, 4, 5),
      amount: 200.0,
      recordType: RecordType.income,
      incomeCategory: IncomeCategory.freelance,
    ),
    TransactionRecord(
      title: "Monthly Salary",
      date: DateTime(2024, 4, 7),
      amount: 3000.0,
      recordType: RecordType.income,
      incomeCategory: IncomeCategory.salary,
    ),
    TransactionRecord(
      title: "Birthday Gift",
      date: DateTime(2024, 4, 8),
      amount: 50.0,
      recordType: RecordType.income,
      incomeCategory: IncomeCategory.gift,
    ),
    TransactionRecord(
      title: "Dividend Income",
      date: DateTime(2024, 4, 9),
      amount: 150.0,
      recordType: RecordType.income,
      incomeCategory: IncomeCategory.investment,
    ),
    TransactionRecord(
      title: "Freelance Project",
      date: DateTime(2024, 4, 10),
      amount: 400.0,
      recordType: RecordType.income,
      incomeCategory: IncomeCategory.freelance,
    ),
    // Add more dummy records as needed...
  ];