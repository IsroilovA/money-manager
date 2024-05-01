import 'package:flutter/material.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/home/widgets/record_item.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key, required this.records});

  final Future<List<TransactionRecord>?> records;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All transactions"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
          future: records,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return snapshot.data == null
                  ? const Center(
                      child: Text("No records yet"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final record = snapshot.data![index];
                        return RecordItem(
                          record: record,
                          onRecordDeleted: (value) {},
                        );
                      },
                    );
            }
          },
        ),
      ),
    );
  }
}
