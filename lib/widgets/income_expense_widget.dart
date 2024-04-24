import 'package:flutter/material.dart';

class IncomeExpenseWidget extends StatelessWidget {
  const IncomeExpenseWidget({
    super.key,
    required this.value,
    required this.isIncome,
  });

  final String value;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              isIncome ? Icons.arrow_circle_down : Icons.arrow_circle_up,
              size: 37,
              color: isIncome ? Colors.green : Colors.red,
            ),
            const SizedBox(
              width: 3,
            ),
            Column(children: [
              Text(
                isIncome ? "Income" : "Expense",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
