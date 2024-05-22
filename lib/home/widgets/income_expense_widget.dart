import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/all_transactions/transactions_list_screen.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class IncomeExpenseWidget extends StatefulWidget {
  const IncomeExpenseWidget({
    super.key,
    required this.isIncome,
  });

  final bool isIncome;

  @override
  State<IncomeExpenseWidget> createState() => _IncomeExpenseWidgetState();
}

class _IncomeExpenseWidgetState extends State<IncomeExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<TabsCubit>(context),
                ),
                BlocProvider(
                  create: (context) => HomeCubit(),
                )
              ],
              child: TransactionsListScreen(
                filter:
                    widget.isIncome ? RecordType.income : RecordType.expense,
              ),
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Icon representing income or expense
              Icon(
                widget.isIncome
                    ? Icons.arrow_circle_down
                    : Icons.arrow_circle_up,
                size: 37,
                color: widget.isIncome ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 3),
              Column(
                children: [
                  // Display "Income" or "Expense" based on the widget's state
                  Text(
                    widget.isIncome ? "Income" : "Expense",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  BlocBuilder<TabsCubit, TabsState>(
                    buildWhen: (previous, current) {
                      // Rebuild widget when transactions are added, deleted, or accounts are loaded
                      if (current is TabsTransactionAdded ||
                          current is TabsTransactionDeleted ||
                          current is TabsLoading ||
                          current is TabsAccountsLoaded) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is TabsTransactionAdded ||
                          state is TabsTransactionDeleted ||
                          state is TabsAccountsLoaded) {
                        BlocProvider.of<HomeCubit>(context)
                            .getTotalRecordTypeAmount();
                        Map<RecordType, double> balancesByCategories =
                            context.select((HomeCubit cubit) =>
                                cubit.balancesByCategories);
                        return Text(
                          widget.isIncome
                              ? insertCommas(
                                  balancesByCategories[RecordType.income]
                                      .toString())
                              : insertCommas(
                                  balancesByCategories[RecordType.expense]
                                      .toString()),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        );
                      } else if (state is TabsLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else {
                        return Text(
                          "Error",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        );
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
