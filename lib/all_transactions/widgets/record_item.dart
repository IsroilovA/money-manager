import 'package:flutter/material.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';

class RecordItem extends StatelessWidget {
  const RecordItem(
      {super.key,
      required this.transactionRecord,
      required this.accounts,
      required this.onRecordDeleted});
  final TransactionRecord transactionRecord;
  final ValueChanged<TransactionRecord> onRecordDeleted;
  final List<Account> accounts;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          onDismissed: (direction) {
            onRecordDeleted(transactionRecord);
          },
          direction: DismissDirection.endToStart,
          background: Material(
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          key: ValueKey(transactionRecord.id),
          child: Material(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(9),
            child: transactionRecord.recordType == RecordType.transfer
                ? ListTile(
                    leading: const Icon(Icons.swap_horiz_rounded),
                    title: Text(
                        "${accounts.firstWhere((account) => account.id == transactionRecord.accountId).name} -> ${accounts.firstWhere((account) => account.id == transactionRecord.transferAccount2Id).name}"),
                    subtitle: transactionRecord.note != null
                        ? Text(
                            "${transactionRecord.note!} | ${formatter.format(transactionRecord.date)}")
                        : Text(formatter.format(transactionRecord.date)),
                    trailing: Text(
                      transactionRecord.formattedAmount,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.blue,
                          ),
                    ),
                  )
                : ListTile(
                    leading: Icon(
                        transactionRecord.recordType == RecordType.income
                            ? categoryIcons[transactionRecord.incomeCategory]
                            : categoryIcons[transactionRecord.expenseCategory]),
                    title: Text(transactionRecord.recordType ==
                            RecordType.income
                        ? transactionRecord.incomeCategory!.name.toUpperCase()
                        : transactionRecord.expenseCategory!.name
                            .toUpperCase()),
                    subtitle: transactionRecord.note != null
                        ? Text(
                            "${transactionRecord.note!} | ${formatter.format(transactionRecord.date)}")
                        : Text(formatter.format(transactionRecord.date)),
                    trailing: Text(
                      transactionRecord.recordType == RecordType.income
                          ? '+ ${transactionRecord.formattedAmount}'
                          : '- ${transactionRecord.formattedAmount}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color:
                              transactionRecord.recordType == RecordType.income
                                  ? Colors.green
                                  : Colors.red),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
