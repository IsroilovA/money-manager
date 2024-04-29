import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/home/widgets/income_expense_widget.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, required this.account});
  final Account account;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    double totalBalance = widget.account.balance;
    return Card(
      margin: const EdgeInsets.all(3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total Balance",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 19,
                  ),
            ),
            Text(
              currencyFormatter.format(totalBalance),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Monthly Expenses",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: LinearProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                value: 2 / 3,
                minHeight: 10,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.account.formattedExpenseLast30Days,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                Text(
                  currencyFormatter.format(totalBalance),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IncomeExpenseWidget(
                    value: widget.account.formattedIncomeLast30Days,
                    isIncome: true),
                IncomeExpenseWidget(
                    value: widget.account.formattedExpenseLast30Days,
                    isIncome: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

var currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$');
