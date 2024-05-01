import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/add_transaction/widgets/account_selector_button.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/add_transaction/widgets/category_selector_button.dart';
import 'package:money_manager/add_transaction/widgets/date_selector_button.dart';

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
  Account? _account;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      if (pickedDate != null) {
        _selectedDate = pickedDate;
      }
    });
  }

  void _showDialog(String text) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input!"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input!"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  void _saveTransaction() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    final noteNotEntered = _noteController.text.trim().isEmpty;
    TransactionRecord newRecord;
    if (amountIsInvalid) {
      _showDialog("enter a valid amount");
      return;
    } else if (_expenseCategory == null && _incomeCategory == null) {
      _showDialog("Select the category");
      return;
    } else if (_account == null) {
      _showDialog("Select account");
      return;
    }

    if (_expenseCategory != null) {
      if (noteNotEntered) {
        newRecord = TransactionRecord(
            accountId: _account!.id,
            date: _selectedDate,
            amount: enteredAmount,
            recordType: widget.recordType,
            expenseCategory: _expenseCategory);
      } else {
        newRecord = TransactionRecord(
            accountId: _account!.id,
            date: _selectedDate,
            amount: enteredAmount,
            recordType: widget.recordType,
            expenseCategory: _expenseCategory,
            note: _noteController.text);
      }
    } else {
      if (noteNotEntered) {
        newRecord = TransactionRecord(
            accountId: _account!.id,
            date: _selectedDate,
            amount: enteredAmount,
            recordType: widget.recordType,
            incomeCategory: _incomeCategory);
      } else {
        newRecord = TransactionRecord(
            accountId: _account!.id,
            date: _selectedDate,
            amount: enteredAmount,
            recordType: widget.recordType,
            incomeCategory: _incomeCategory,
            note: _noteController.text);
      }
    }
    Navigator.of(context).pop(newRecord);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
          leading: const Text("Date"),
          title: DateSelectorButton(
            onClick: _presentDatePicker,
            selectedDate: _selectedDate,
          ),
          minLeadingWidth: width / 5,
        ),
        ListTile(
          leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
          leading: const Text('Amount'),
          minLeadingWidth: width / 5,
          title: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _amountController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d+\.?\d{0,2}'),
              ),
            ],
            maxLines: 1,
            maxLength: 20,
            decoration: const InputDecoration(
              prefixText: '\$ ',
            ),
          ),
        ),
        ListTile(
            leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Text("Category"),
            minLeadingWidth: width / 5,
            title: CategorySelectorButton(
              recordType: widget.recordType,
              onExpenseChanged: (value) {
                _expenseCategory = value;
              },
              onIncomeChanged: (value) {
                _incomeCategory = value;
              },
            )),
        ListTile(
          leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
          leading: const Text("Account"),
          minLeadingWidth: width / 5,
          title: AccountSelectorButton(
            onAccountChanged: (value) {
              _account = value;
            },
          ),
        ),
        ListTile(
          leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
          leading: const Text("Note"),
          minLeadingWidth: width / 5,
          title: TextField(
            controller: _noteController,
            maxLines: 1,
            maxLength: 60,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: _saveTransaction,
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: Size(width * 2 / 3, 0),
                textStyle: Theme.of(context).textTheme.titleMedium,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.titleMedium,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.deepPurple),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              child: const Text('Cancel'),
            )
          ],
        )
      ],
    );
  }
}
