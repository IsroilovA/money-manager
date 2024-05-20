import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/all_transactions/widgets/record_item.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All transactions"),
        centerTitle: true,
      ),
      body: BlocBuilder<TabsCubit, TabsState>(
        buildWhen: (previous, current) {
          if (current is TabsTransactionDeleted ||
              current is TabsAccountsLoaded ||
              current is TabsTransactionAdded ||
              current is TabsLoading) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is TabsTransactionDeleted ||
              state is TabsTransactionAdded ||
              state is TabsAccountsLoaded) {
            BlocProvider.of<HomeCubit>(context).loadTransactions();
            return BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeNoTransactions) {
                  return Center(
                    child: Text(
                      "No records yet",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  );
                } else if (state is HomeTransactionsLoading) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else if (state is HomeTransactionsLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.transactionRecords.length,
                    itemBuilder: (context, index) {
                      final record = state.transactionRecords[index];
                      return RecordItem(
                        transactionRecord: record,
                      );
                    },
                  );
                } else if (state is HomeError) {
                  return Center(
                    child: Text(
                      "Error: ${state.message}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Something is wrong",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  );
                }
              },
            );
          } else if (state is TabsLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            return Center(
              child: Text(
                "Something is wrong2",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            );
          }
        },
      ),
    );
  }
}
