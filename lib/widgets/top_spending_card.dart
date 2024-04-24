import 'package:flutter/material.dart';

class TopSpendingCard extends StatelessWidget {
  const TopSpendingCard(
      {super.key, required this.icon, required this.category});
  final IconData icon;
  final String category;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.surfaceVariant,
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
