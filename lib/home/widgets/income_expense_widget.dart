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
                          current is TabsAccountsLoaded) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state is TabsTransactionAdded ||
                          state is TabsTransactionDeleted ||
                          state is TabsAccountsLoaded) {
                        // Fetch total amounts for income and expense
                        BlocProvider.of<HomeCubit>(context)
                            .getTotalRecordTypeAmount();
                        double expense = context
                            .select((HomeCubit cubit) => cubit.totalExpense);
                        double income = context
                            .select((HomeCubit cubit) => cubit.totalIncome);
                        return Text(
                          widget.isIncome
                              ? currencyFormatter.format(income)
                              : currencyFormatter.format(expense),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        );
                      } else {
                        return Text(
                          "Error",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        );
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
