import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';

class IncomeExpenseWidget extends StatelessWidget {
  const IncomeExpenseWidget({
    super.key,
    required this.isIncome,
  });

  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              isIncome ? Icons.arrow_circle_down : Icons.arrow_circle_up,
              size: 37,
              color: isIncome ? Colors.green : Colors.red,
            ),
            const SizedBox(
              width: 3,
            ),
            Column(
              children: [
                Text(
                  isIncome ? "Income" : "Expense",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                BlocProvider(
                  create: (context) => HomeCubit(),
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      BlocProvider.of<HomeCubit>(context).loadTransactions();
                      if (state is HomeTransactionsLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (state is HomeNoTransactions) {
                        return Text(
                          '0',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        );
                      } else if (state is HomeTransactionsLoaded) {
                        final DateTime today = DateTime.now();
                        final DateTime thirtyDaysAgo =
                            today.subtract(const Duration(days: 30));
                        double expense = 0.0;
                        double income = 0.0;
                        for (var transactionRecord
                            in state.transactionRecords) {
                          if (transactionRecord.date.isAfter(thirtyDaysAgo)) {
                            if (transactionRecord.recordType ==
                                RecordType.expense) {
                              expense += transactionRecord.amount;
                            } else if (transactionRecord.recordType ==
                                RecordType.income) {
                              income += transactionRecord.amount;
                            }
                          }
                        }

                        return Text(
                          isIncome
                              ? currencyFormatter.format(income)
                              : currencyFormatter.format(expense),
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        );
                      } else if (state is HomeError) {
                        return Center(
                          child: Text(
                            "Error: ${state.message}",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      } else {
                        return const Center(child: Text("Something is wrond"));
                      }
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
