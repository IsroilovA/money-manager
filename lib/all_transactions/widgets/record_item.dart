import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class RecordItem extends StatelessWidget {
  const RecordItem({super.key, required this.transactionRecord});
  final TransactionRecord transactionRecord;

  @override
  Widget build(BuildContext context) {
    // Get the list of accounts from the TabsCubit
    final accounts = context.select((TabsCubit cubit) => cubit.accounts);

    return Column(
      children: [
        InkWell(
          onTap: () {
            // If the transaction is not a balance adjustment, allow editing
            if (transactionRecord.recordType != RecordType.balanceAdjustment) {
              context
                  .read<TabsCubit>()
                  .editTransaction(context, transactionRecord);
            }
          },
          child: Dismissible(
            // Handle the deletion of a transaction
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
              child: buildListTile(transactionRecord, accounts, context),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Function to build the ListTile widget based on the record type
  Widget buildListTile(
      TransactionRecord record, List<Account> accounts, BuildContext context) {
    switch (record.recordType) {
      case RecordType.transfer:
        return ListTile(
          leading: const Icon(Icons.swap_horiz_rounded),
          title: Text(
            "${accounts.firstWhere((account) => account.id == record.accountId).name} -> ${accounts.firstWhere((account) => account.id == record.transferAccount2Id).name}",
          ),
          subtitle: record.note != null
              ? Text("${record.note!} | ${record.formattedDate}")
              : Text(record.formattedDate),
          trailing: Text(
            record.formattedAmount,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.blue,
                ),
          ),
        );
      case RecordType.balanceAdjustment:
        return ListTile(
          leading: const Icon(Icons.edit),
          title: Text(
            "${accounts.firstWhere((account) => account.id == record.accountId).name} Balance Adjustment",
          ),
          subtitle: record.note != null
              ? Text("${record.note!} | ${record.formattedDate}")
              : Text(record.formattedDate),
          trailing: Text(
            record.formattedAmount,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.blue,
                ),
          ),
        );
      default:
        return ListTile(
          leading: Icon(
            record.recordType == RecordType.income
                ? categoryIcons[record.incomeCategory]
                : categoryIcons[record.expenseCategory],
          ),
          title: Text(
            record.recordType == RecordType.income
                ? record.incomeCategory!.name.capitalize()
                : record.expenseCategory!.name.capitalize(),
          ),
          subtitle: record.note != null
              ? Text("${record.note!} | ${record.formattedDate}")
              : Text(record.formattedDate),
          trailing: Text(
            record.recordType == RecordType.income
                ? '+ ${record.formattedAmount}'
                : '- ${record.formattedAmount}',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: record.recordType == RecordType.income
                    ? Colors.green
                    : Colors.red),
          ),
        );
    }
  }
}
