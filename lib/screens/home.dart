import 'package:flutter/material.dart';
import 'package:money_manager/data/dummy_data.dart';
import 'package:money_manager/models/account.dart';
import 'package:money_manager/models/transaction_record.dart';
import 'package:money_manager/widgets/balance_card.dart';

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

class RecordItem extends StatelessWidget {
  RecordItem({super.key, required this.record});
  TransactionRecord record;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(record.recordType == RecordType.income
          ? categoryIcons[record.incomeCategory]
          : categoryIcons[record.expenseCategory]),
      title: Text(record.recordType == RecordType.income
          ? record.incomeCategory.toString()
          : record.expenseCategory.toString()),
      subtitle: Text(record.title),
      trailing: Text(
        record.recordType == RecordType.income
            ? '+ ${record.formattedAmount}'
            : '- ${record.formattedAmount}',
        style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: record.recordType == RecordType.income? Colors.green : Colors.red ),
      ),
    );
  }
}

class TopSpendingCard extends StatelessWidget {
  const TopSpendingCard(
      {super.key, required this.icon, required this.category});
  final IconData icon;
  final String category;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Container(
          width: 85,
          padding: const EdgeInsets.all(3),
          child: Column(
            children: [
              Icon(
                icon,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                category,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                    ),
              )
            ],
          ),
        ));
  }
}
