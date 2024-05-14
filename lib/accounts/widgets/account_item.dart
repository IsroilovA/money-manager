import 'package:flutter/material.dart';
import 'package:money_manager/data/models/account.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            account.name.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            account.formattedBalance,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: account.balance >= 0 ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }
}
