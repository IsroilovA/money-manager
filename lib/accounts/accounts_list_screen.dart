import 'package:flutter/material.dart';
import 'package:money_manager/accounts/widgets/account_item.dart';
import 'package:money_manager/data/models/account.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key, required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: accounts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return AccountItem(account: accounts[index]);
        },
      ),
    );
  }
}
