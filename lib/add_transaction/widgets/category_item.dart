import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.icon,
    required this.category,
    required this.onCLick,
  });

  // The icon displayed at the begining
  final IconData icon;
  // The category displayed
  final String category;
  /// The callback function to be triggered when the button is clicked.
  final void Function() onCLick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCLick,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          border: Border.all(
            width: 0.3,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon representing the category
            Icon(
              icon,
              size: 25,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            // Text displaying the category name
            Text(
              category,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
