import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/transaction_record.dart';

final formatter = DateFormat.yMd();

class AddNewTransaction extends StatefulWidget {
  const AddNewTransaction({super.key});

  @override
  State<AddNewTransaction> createState() {
    return _AddNewTransactionState();
  }
}

class _AddNewTransactionState extends State<AddNewTransaction> {
  RecordType _recordType = RecordType.income;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Column(
          children: [
            TabBar(
              //make the indicator the size of the full tab
              indicatorSize: TabBarIndicatorSize.tab,
              //remove deivder
              dividerHeight: 0,
              onTap: (index) {
                _recordType = RecordType.values[index];
              },
              indicator: BoxDecoration(
                border: Border.all(
                    width: 1, color: Theme.of(context).colorScheme.primary),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              tabs: const [
                Tab(
                  text: 'Income',
                ),
                Tab(
                  text: 'Expense',
                ),
                Tab(
                  text: 'Transfer',
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                //to not change the tabs when swiped
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TransactionForm(
                    recordType: _recordType,
                  ),
                  Column(),
                  Text('data3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, required this.recordType});

  final RecordType recordType;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExpenseCategory? _expenseCategory;
  IncomeCategory? _incomeCategory;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      if (pickedDate != null) {
        _selectedDate = pickedDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
          leading: const Text("Date"),
          title: Text(formatter.format(_selectedDate)),
          minLeadingWidth: 70,
          onTap: _presentDatePicker,
        ),
        ListTile(
          leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
          leading: const Text('Amount'),
          minLeadingWidth: 70,
          title: TextField(
            keyboardType: const TextInputType.numberWithOptions(),
            controller: _amountController,
          ),
        ),
      ],
    );
  }
}
