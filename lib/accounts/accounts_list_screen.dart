import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/accounts/widgets/account_item.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key, required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: accounts.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          crossAxisCount: 2,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return (index != accounts.length)
              ? AccountItem(account: accounts[index])
              : InkWell(
                  onTap: () {
                    BlocProvider.of<TabsCubit>(context).addAccount(context);
                  },
                  child: const Card(
                    elevation: 2,
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
