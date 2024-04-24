import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/account.dart';
import 'package:money_manager/widgets/income_expense_widget.dart';

class BalanceCard extends StatefulWidget {
  BalanceCard({super.key, required this.account});
  Account account;
  @override
  State<BalanceCard> createState() {
    return _BalanceCardState();
  }
}

var currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$');

class _BalanceCardState extends State<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    double totalBalance = widget.account.balance;
    double income = widget.account.income;
    double expenses = widget.account.expense;
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
                value: expenses / income,
                minHeight: 10,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currencyFormatter.format(expenses),
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
                    value: currencyFormatter.format(widget.account.income),
                    isIncome: true),
                IncomeExpenseWidget(
                    value: currencyFormatter.format(widget.account.expense),
                    isIncome: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}