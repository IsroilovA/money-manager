import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/helper_fucntions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class RecordItem extends StatelessWidget {
  const RecordItem(
      {super.key, required this.transactionRecord, required this.accounts});
  final TransactionRecord transactionRecord;
  final List<Account> accounts;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (transactionRecord.recordType != RecordType.balanceAdjustment) {
              context
                  .read<TabsCubit>()
                  .editTransaction(context, transactionRecord);
            }
          },
          child: Dismissible(
            onDismissed: (direction) {
              BlocProvider.of<TabsCubit>(context)
                  .deleteTransaction(transactionRecord);
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
              child: switch (transactionRecord.recordType) {
                RecordType.transfer => ListTile(
                    leading: const Icon(Icons.swap_horiz_rounded),
                    title: Text(
                        "${accounts.firstWhere((account) => account.id == transactionRecord.accountId).name} -> ${accounts.firstWhere((account) => account.id == transactionRecord.transferAccount2Id).name}"),
                    subtitle: transactionRecord.note != null
                        ? Text(
                            "${transactionRecord.note!} | ${transactionRecord.formattedDate}")
                        : Text(transactionRecord.formattedDate),
                    trailing: Text(
                      transactionRecord.formattedAmount,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.blue,
                          ),
                    ),
                  ),
                RecordType.balanceAdjustment => ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(
                        "${accounts.firstWhere((account) => account.id == transactionRecord.accountId).name} Balance Adjustment"),
                    subtitle: transactionRecord.note != null
                        ? Text(
                            "${transactionRecord.note!} | ${transactionRecord.formattedDate}")
                        : Text(transactionRecord.formattedDate),
                    trailing: Text(
                      transactionRecord.formattedAmount,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.blue,
                          ),
                    ),
                  ),
                _ => ListTile(
                    leading: Icon(
                        transactionRecord.recordType == RecordType.income
                            ? categoryIcons[transactionRecord.incomeCategory]
                            : categoryIcons[transactionRecord.expenseCategory]),
                    title: Text(transactionRecord.recordType ==
                            RecordType.income
                        ? transactionRecord.incomeCategory!.name.capitalize()
                        : transactionRecord.expenseCategory!.name.capitalize()),
                    subtitle: transactionRecord.note != null
                        ? Text(
                            "${transactionRecord.note!} | ${transactionRecord.formattedDate}")
                        : Text(transactionRecord.formattedDate),
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
                  )
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
