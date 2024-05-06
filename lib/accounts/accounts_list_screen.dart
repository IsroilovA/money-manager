import 'package:flutter/material.dart';
import 'package:money_manager/accounts/widgets/account_item.dart';
import 'package:money_manager/data/models/account.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key, required this.acocunts});

  final List<Account> acocunts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: acocunts.length,
        itemBuilder: (context, index) {
          final account = acocunts[index];
          return AccountItem(
            account: account,
          );
        },
      ),
    );
  }
}
