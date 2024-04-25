import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/transaction_record.dart';
import 'package:money_manager/widgets/custom_input_button.dart';

final formatter = DateFormat.yMd();

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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
          leading: const Text("Date"),
          title: CustomInputButton(
            onClick: _presentDatePicker,
            selectedValue: formatter.format(_selectedDate),
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
          title: CustomInputButton(
            selectedValue: widget.recordType == RecordType.expense
                ? _expenseCategory
                : _incomeCategory,
            onClick: () {},
          ),
        ),
        ListTile(
            leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Text("Account"),
            minLeadingWidth: width / 5,
            title: CustomInputButton(onClick: () {}, selectedValue: " ")),
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
              onPressed: () {},
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
              onPressed: () {},
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
