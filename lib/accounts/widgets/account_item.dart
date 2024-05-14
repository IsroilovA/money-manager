import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            account.name.toUpperCase(),
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
                        snapshot.data.toString(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: account.balance >= 0
                                ? Colors.green
                                : Colors.red),
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
                      color: account.balance >= 0 ? Colors.green : Colors.red),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
