import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/accounts/cubit/account_details_cubit.dart';
import 'package:money_manager/accounts/widgets/account_details.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/services/helper_fucntions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({super.key, required this.account, required this.accounts});

  final Account account;
  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AccountDetailsCubit(),
                ),
                BlocProvider(
                  create: (context) => TabsCubit(),
                ),
              ],
              child: AccountDetails(
                account: account,
                accounts: accounts,
              ),
            ),
          ),
        );
        if (context.mounted) {
          BlocProvider.of<TabsCubit>(context).loadAccounts();
        }
      },
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              account.name.capitalize(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            BlocBuilder<TabsCubit, TabsState>(
              buildWhen: (previous, current) {
                if (current is TabsTransactionAdded ||
                    current is TabsTransactionDeleted) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is TabsTransactionAdded ||
                    state is TabsTransactionDeleted) {
                  Future<double> balance = BlocProvider.of<TabsCubit>(context)
                      .getAccountBalance(account.id);
                  return FutureBuilder(
                    future: balance,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          currencyFormatter.format(snapshot.data),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: snapshot.data! >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                        );
                      } else {
                        return const CircularProgressIndicator.adaptive();
                      }
                    },
                  );
                } else {
                  return Text(
                    account.formattedBalance,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color:
                            account.balance >= 0 ? Colors.green : Colors.red),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
