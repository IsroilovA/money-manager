import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomInputButton extends StatefulWidget {
  const CustomInputButton(
      {super.key,
      this.selectedCategory,
      required this.onClick,
      this.selectedDate});

  final Enum? selectedCategory;

  final String? selectedDate;

  final void Function() onClick;

  @override
  State<CustomInputButton> createState() => _CustomInputButtonState();
}

class _CustomInputButtonState extends State<CustomInputButton> {
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.selectedCategory != null && widget.selectedDate == null) {
      content = Text(widget.selectedCategory!.name);
    } else if (widget.selectedDate != null) {
      content = Text(widget.selectedDate!);
    } else {
      content = const Text("");
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: TextButton(
          onPressed: widget.onClick,
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
