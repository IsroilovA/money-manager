import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/accounts/widgets/account_item.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

/// A screen that displays a grid of accounts. It also provides an option to add a new account.
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Select the list of accounts from the TabsCubit
    final accounts = context.select((TabsCubit cubit) => cubit.accounts);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: accounts.length + 1, // Add 1 for the 'Add Account' card
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          crossAxisCount: 2,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return (index != accounts.length)
              ? AccountItem(
                  account: accounts[index],
                  accounts: accounts,
                )
              : InkWell(
                  onTap: () {
                    // Trigger the addAccount function when the 'Add Account' card is tapped
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