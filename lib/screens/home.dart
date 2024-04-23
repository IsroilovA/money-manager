import 'package:flutter/material.dart';
import 'package:money_manager/widgets/balance_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BalanceCard(),
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
          )
        ],
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
