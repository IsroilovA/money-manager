import 'package:flutter/material.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/home/widgets/record_item.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All transactions"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: account.records.length,
            itemBuilder: ((context, index) {
              final record = account.records[index];
              return RecordItem(record: record);
            })),
      ),
    );
  }
}
