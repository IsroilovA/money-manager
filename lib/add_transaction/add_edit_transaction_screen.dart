import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/add_transaction/widgets/transaction_form.dart';

class AddEditTransaction extends StatefulWidget {
  const AddEditTransaction({super.key, this.transactionRecord});

  final TransactionRecord? transactionRecord;

  @override
  State<AddEditTransaction> createState() {
    return _AddEditTransactionState();
  }
}

class _AddEditTransactionState extends State<AddEditTransaction> {
  @override
  void initState() {
    if (widget.transactionRecord != null) {
      BlocProvider.of<AddTransactionCubit>(context)
          .selectRecordType(widget.transactionRecord!.recordType.index);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RecordType recordType =
        context.select((AddTransactionCubit cubit) => cubit.recordType);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: recordType.index,
        child: Column(
          children: [
            TabBar(
              //make the indicator the size of the full tab
              indicatorSize: TabBarIndicatorSize.tab,
              //remove deivder
              dividerHeight: 0,
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
