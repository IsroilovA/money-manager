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
        width: MediaQuery.of(context).size.width / 4.7,
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            // Icon representing the spending category
            Icon(
              icon,
              size: 55,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 10),
            // Text displaying the category name
            Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}