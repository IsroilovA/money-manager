import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/add_transaction/widgets/transaction_form.dart';

/// A screen for adding or editing a transaction.
class AddEditTransaction extends StatefulWidget {
  const AddEditTransaction({super.key, this.transactionRecord});

  /// The transaction record to be edited, if any.
  final TransactionRecord? transactionRecord;

  @override
  State<AddEditTransaction> createState() {
    return _AddEditTransactionState();
  }
}

class _AddEditTransactionState extends State<AddEditTransaction> {
  @override
  void initState() {
    super.initState();
    // If editing an existing transaction, set the record type in the cubit.
    if (widget.transactionRecord != null) {
      BlocProvider.of<AddTransactionCubit>(context)
          .selectRecordType(widget.transactionRecord!.recordType.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current record type from the cubit.
    RecordType recordType =
        context.select((AddTransactionCubit cubit) => cubit.recordType);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transactionRecord == null
            ? 'New Transaction'
            : 'Edit Transaction'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: recordType.index,
        child: Column(
          children: [
            // A tab bar to switch between income, expense, and transfer tabs.
            TabBar(
              // Make the indicator the size of the full tab.
              indicatorSize: TabBarIndicatorSize.tab,
              // Remove the divider.
              dividerColor: Colors.transparent,
              // Change the record type in the cubit when a tab is tapped.
              onTap: BlocProvider.of<AddTransactionCubit>(context)
                  .selectRecordType,
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
            // Display the transaction form corresponding to the selected tab.
            Expanded(
              child: TransactionForm(
                recordType: recordType,
                transactionRecord: widget.transactionRecord,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
