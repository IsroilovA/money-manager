import 'package:flutter/material.dart';
import 'package:money_manager/data/dummy_data.dart';
import 'package:money_manager/models/account.dart';
import 'package:money_manager/widgets/balance_card.dart';
import 'package:money_manager/widgets/record_item.dart';
import 'package:money_manager/widgets/top_spending_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Account account = dummyAccount;
    //account.records = account.records.sort((a, b) => a.date.compareTo(b.date),);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(
            height: 18,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TopSpendingCard(
                  icon: Icons.soup_kitchen_outlined, category: "Food"),
              TopSpendingCard(
                  icon: Icons.local_gas_station_outlined, category: "Fuel"),
              TopSpendingCard(icon: Icons.luggage_outlined, category: "Travel"),
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
                onPressed: () {},
                child: const Text("View all"),
              )
            ],
          ),
          Column(
            children: [
              for (var record in account.records.sublist(1, 8))
                RecordItem(record: record)
            ],
          )
        ],
      ),
    );
  }
}
