import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:money_manager/add_transaction/widgets/category_item.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/helper_functions.dart';

/// A button widget that allows the user to select a category for a transaction.
class CategorySelectorButton extends StatefulWidget {
  const CategorySelectorButton({
    super.key,
    required this.recordType,
    this.onExpenseChanged,
    this.onIncomeChanged,
    this.selectedCategory,
  });

  /// The type of record (expense or income).
  final RecordType recordType;

  /// Callback for when an expense category is selected.
  final ValueChanged<ExpenseCategory>? onExpenseChanged;

  /// Callback for when an income category is selected.
  final ValueChanged<IncomeCategory>? onIncomeChanged;

  /// The currently selected category, if any.
  final Enum? selectedCategory;

  @override
  State<CategorySelectorButton> createState() => _CategorySelectorButtonState();
}

class _CategorySelectorButtonState extends State<CategorySelectorButton> {
  Enum? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Initialize the selected category if provided.
    if (widget.selectedCategory != null) {
      _selectedCategory = widget.selectedCategory;
    }
  }

  /// Opens a bottom sheet to allow the user to select a category.
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
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
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
                              _selectedCategory = category;
                            });
                            widget.onExpenseChanged?.call(category);
                            Navigator.of(context).pop();
                          },
                          icon: categoryIcons[category]!,
                          category: category.name.capitalize(),
                        )
                    else
                      for (final category in IncomeCategory.values)
                        CategoryItem(
                          onCLick: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                            widget.onIncomeChanged?.call(category);
                            Navigator.of(context).pop();
                          },
                          icon: categoryIcons[category]!,
                          category: category.name.capitalize(),
                        )
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
    // Display the selected category name or an empty text widget if none selected.
    Widget content = const Text("");
    if (_selectedCategory != null) {
      content = Text(_selectedCategory!.name.capitalize());
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
        ),
      ),
      child: BlocListener<AddTransactionCubit, AddTransactionState>(
        listener: (context, state) {
          if (state is RecordTypeChanged) {
            setState(() {
              _selectedCategory = null;
            });
          }
        },
        child: TextButton(
          onPressed: _openBottomSheet,
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.centerLeft,
          ),
          child: content,
        ),
      ),
    );
  }
}
