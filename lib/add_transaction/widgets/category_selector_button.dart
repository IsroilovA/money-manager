import 'package:flutter/material.dart';
import 'package:money_manager/add_transaction/widgets/category_item.dart';
import 'package:money_manager/data/models/transaction_record.dart';

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
      shape: const ContinuousRectangleBorder(),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Category",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                  ),
                  children: [
                    if (widget.recordType == RecordType.expense)
                      for (final category in ExpenseCategory.values)
                        CategoryItem(
                            onCLick: () {
                              setState(() {
                                _expenseCategory = category;
                              });
                              widget.onExpenseChanged!(category);
                              Navigator.of(context).pop();
                            },
                            icon: categoryIcons[category]!,
                            category: category.name)
                    else
                      for (final category in IncomeCategory.values)
                        CategoryItem(
                            onCLick: () {
                              setState(() {
                                _incomeCategory = category;
                              });
                              widget.onIncomeChanged!(category);
                              Navigator.of(context).pop();
                            },
                            icon: categoryIcons[category]!,
                            category: category.name)
                  ],
                ),
              ),
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
