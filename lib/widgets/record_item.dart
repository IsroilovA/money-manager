import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction_record.dart';

class RecordItem extends StatelessWidget {
  RecordItem({super.key, required this.record});
  TransactionRecord record;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(9),
          child: ListTile(
            leading: Icon(record.recordType == RecordType.income
                ? categoryIcons[record.incomeCategory]
                : categoryIcons[record.expenseCategory]),
            title: Text(record.recordType == RecordType.income
                ? record.incomeCategory.toString()
                : record.expenseCategory.toString()),
            subtitle: Text(record.title),
            trailing: Text(
              record.recordType == RecordType.income
                  ? '+ ${record.formattedAmount}'
                  : '- ${record.formattedAmount}',
              style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: record.recordType == RecordType.income? Colors.green : Colors.red ),
            ),
          ),
        ),
        const SizedBox(height: 10,),
      ],
    );
  }
}
