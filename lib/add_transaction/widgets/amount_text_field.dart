import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom [TextField] widget for entering amounts, formatted with a specified [TextInputFormatter].
class AmountTextField extends StatelessWidget {
  const AmountTextField({
    super.key,
    required this.amountController,
    required this.textInputFormatter,
  });

  /// The controller that manages the text being edited.
  final TextEditingController amountController;

  /// The input formatter used to format the text input.
  final TextInputFormatter textInputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextField(
      // Disables interactive selection of the text.
      enableInteractiveSelection: false,
      // Hides the cursor from the text field.
      showCursor: false,
      // Sets the text style to match the current theme with a primary color.
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.primary),
      // Restricts the input type to numbers with options for decimal input.
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // Associates the controller with the text field.
      controller: amountController,
      // Applies the specified text input formatter.
      inputFormatters: [textInputFormatter],
      // Limits the text field to a single line.
      maxLines: 1,
      // Sets the maximum length of input to 21 characters.
      maxLength: 21,
      // Adds a prefix and removes the counter text from the decoration.
      decoration: const InputDecoration(prefixText: 'UZS ', counterText: ''),
    );
  }
}
