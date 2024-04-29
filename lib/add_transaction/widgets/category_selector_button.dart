import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/home/widgets/top_spending_card.dart';

final formatter = DateFormat.yMd();

class CategorySelectorButton extends StatefulWidget {
  const CategorySelectorButton({
    super.key,
    required this.recordType,
    this.onExpenseChanged,
    this.onIncomeChanged,
  });

  final RecordType recordType;
  final ValueChanged<ExpenseCategory>? onExpenseChanged;
  final ValueChanged<IncomeCategory>? onIncomeChanged;

  @override
  State<CategorySelectorButton> createState() => _CategorySelectorButtonState();
}

class _CategorySelectorButtonState extends State<CategorySelectorButton> {
  ExpenseCategory? _expenseCategory;
  IncomeCategory? _incomeCategory;

  void _openBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          padding: const EdgeInsets.all(20),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            children: [
              if (widget.recordType == RecordType.expense)
                for (final category in ExpenseCategory.values)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _expenseCategory = category;
                      });
                      widget.onExpenseChanged!(category);
                    },
                    child: TopSpendingCard(
                        icon: categoryIcons[category]!,
                        category: category.name),
                  )
              else
                for (final category in IncomeCategory.values)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _incomeCategory = category;
                      });
                      widget.onIncomeChanged!(category);
                    },
                    child: TopSpendingCard(
                        icon: categoryIcons[category]!,
                        category: category.name),
                  )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Text("");
    if (widget.recordType == RecordType.expense && _expenseCategory != null) {
      content = Text(_expenseCategory!.name);
    } else if (widget.recordType == RecordType.income &&
        _incomeCategory != null) {
      content = Text(_incomeCategory!.name);
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: TextButton(
          onPressed: _openBottomSheet,
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.centerLeft,
          ),
          child: content),
    );
  }
}
