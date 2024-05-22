import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/all_transactions/widgets/record_item.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key, this.filter});

  final RecordType? filter;

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  int? selectedIndex;
  List<RecordType> filters = [
    RecordType.income,
    RecordType.expense,
    RecordType.transfer,
    RecordType.balanceAdjustment,
  ];

  @override
  void initState() {
    if (widget.filter != null) {
      selectedIndex = widget.filter!.index;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All transactions"),
        centerTitle: true,
      ),
      body: BlocBuilder<TabsCubit, TabsState>(
        buildWhen: (previous, current) {
          // Rebuild when transactions are added, deleted, or accounts are loaded
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
              state is TabsAccountsLoaded ||
              state is TabsPageChanged) {
            // Load transactions with the selected filter
            BlocProvider.of<HomeCubit>(context).loadTransactions(
                filter: selectedIndex == null ? null : filters[selectedIndex!]);
            return Column(
              children: [
                // Filter chips for different transaction types
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      filters.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        child: ChoiceChip(
                          label: Text(
                            index == 3
                                ? "Balance Adjustments"
                                : "${filters[index].name.capitalize()}s",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          selected: selectedIndex == index,
                          onSelected: (isSelected) {
                            setState(() {
                              selectedIndex = isSelected ? index : null;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Display the list of transactions based on the state
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeNoTransactions) {
                      return Center(
                        child: Text(
                          "No records yet",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Something is wrong",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          } else if (state is TabsLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
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
      ),
    );
  }
}
