import 'package:flutter/material.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/all_transactions/widgets/record_item.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen(
      {super.key, required this.accounts, required this.transactionRecords});

  final List<TransactionRecord> transactionRecords;
  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All transactions"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: transactionRecords.isEmpty
            ? Center(
                child: Text(
                  "No records yet",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                      ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionRecords.length,
                itemBuilder: (context, index) {
                  final record = transactionRecords[index];
                  return RecordItem(
                    accounts: accounts,
                    transactionRecord: record,
                    onRecordDeleted: (value) {},
                  );
                },
              ),
      ),
    );
  }
}
