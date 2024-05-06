import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/data/models/account.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(9),
      child: ListTile(
        title: Text(account.name.toUpperCase()),
        trailing: Text(
          account.formattedBalance,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: account.balance >= 0 ? Colors.green : Colors.red),
        ),
      ),
    );
  }
}
