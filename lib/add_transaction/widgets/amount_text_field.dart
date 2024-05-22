import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    super.key,
    required this.amountController,
    required this.textInputFormatter,
  });

  final TextEditingController amountController;
  final TextInputFormatter textInputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enableInteractiveSelection: false,
      showCursor: false,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.primary),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: amountController,
      inputFormatters: [textInputFormatter],
      maxLines: 1,
      maxLength: 21,
      decoration: const InputDecoration(prefixText: 'UZS ', counterText: ''),
    );
  }
}
