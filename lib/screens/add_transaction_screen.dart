import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/transaction_record.dart';
import 'package:money_manager/widgets/custom_input_button.dart';
import 'package:money_manager/widgets/transaction_form.dart';

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
                  TransactionForm(
                    recordType: _recordType,
                  ),
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
