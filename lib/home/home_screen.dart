import 'package:flutter/material.dart';
import 'package:money_manager/all_transactions/transactions_list_screen.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/home/widgets/balance_card.dart';
import 'package:money_manager/home/widgets/record_item.dart';
import 'package:money_manager/home/widgets/top_spending_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    void viewAllTransactions() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => TransactionsListScreen(
            account: account,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
          children: [
            BalanceCard(account: account),
            const SizedBox(height: 20),
            Text(
              "Top Spendings",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopSpendingCard(
                    icon: Icons.soup_kitchen_outlined, category: "Food"),
                TopSpendingCard(
                    icon: Icons.local_gas_station_outlined, category: "Fuel"),
                TopSpendingCard(
                    icon: Icons.luggage_outlined, category: "Travel"),
                TopSpendingCard(
                    icon: Icons.shopping_cart_outlined, category: "Shopping"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: viewAllTransactions,
                  child: const Text("View all"),
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final record = account.records[index];
                return RecordItem(record: record);
              },
            ),
          ],
        ),
      ),
    );
  }
}
