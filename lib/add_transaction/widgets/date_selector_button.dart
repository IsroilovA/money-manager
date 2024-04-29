import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class DateSelectorButton extends StatefulWidget {
  const DateSelectorButton(
      {super.key, required this.onClick, required this.selectedDate});

  final DateTime selectedDate;

  final void Function() onClick;

  @override
  State<DateSelectorButton> createState() => _DateSelectorButtonState();
}

class _DateSelectorButtonState extends State<DateSelectorButton> {
  @override
  Widget build(BuildContext context) {
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
          child: Text(formatter.format(widget.selectedDate))),
    );
  }
}
