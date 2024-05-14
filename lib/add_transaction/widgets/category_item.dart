import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {super.key,
      required this.icon,
      required this.category,
      required this.onCLick});
  final IconData icon;
  final String category;
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
            Icon(
              icon,
              size: 25,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              category,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
