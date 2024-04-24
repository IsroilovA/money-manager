import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_manager/models/transaction_record.dart';
import 'package:money_manager/widgets/income_expense_widget.dart';

class AddNewTransaction extends StatefulWidget {
  AddNewTransaction({super.key});

  @override
  State<AddNewTransaction> createState() {
    return _AddNewTransactionState();
  }
}

class _AddNewTransactionState extends State<AddNewTransaction> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  ExpenseCategory? _expenseCategory;
  IncomeCategory? _incomeCategory;
  RecordType? _recordType;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Save'),
                    )
                  ],
                ),
                NavigationBar(
                    labelBehavior:
                        NavigationDestinationLabelBehavior.alwaysHide,
                    height: 30,
                    indicatorShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    destinations: [
                      NavigationDestination(
                          icon: Container(
                              width: width / 3,
                              child: const Center(child: Text("Expense"))),
                          label: 'Expense'),
                      const NavigationDestination(
                          icon: Text("Income"), label: 'Income'),
                      NavigationDestination(
                          icon: Container(
                              width: width / 3,
                              child: const Center(child: Text("Transfer"))),
                          label: 'Transfer'),
                    ]),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(label: Text('Title')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter expense name';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(items: [
                        for (final category in ExpenseCategory.values)
                          DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.toString()),
                              ],
                            ),
                          )
                      ], onChanged: (value){
                        _expenseCategory = value;
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }
}
