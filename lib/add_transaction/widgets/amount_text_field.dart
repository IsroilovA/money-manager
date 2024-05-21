import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/services/helper_fucntions.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    super.key,
    required this.amountController,
  });

  final TextEditingController amountController;

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
      inputFormatters: [
        TextInputFormatter.withFunction((oldValue, newValue) {
          final RegExp regExp = RegExp(r'^\d*\.?\d{0,2}$');
          if (newValue.text.isEmpty) {
            return newValue.copyWith(text: '');
          }
          if (regExp.hasMatch(newValue.text.replaceAll(',', ''))) {
            String newText = insertComas(newValue.text.replaceAll(',', ''));
            return newValue.copyWith(
              text: newText,
              selection: TextSelection.collapsed(offset: newText.length),
            );
          }
          return oldValue;
        }),
      ],
      maxLines: 1,
      maxLength: 20,
      decoration: const InputDecoration(
        prefixText: 'UZS ',
      ),
    );
  }
}
