import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

/// A button widget that displays a formatted date and triggers an action when pressed.
class DateSelectorButton extends StatefulWidget {
  const DateSelectorButton({
    super.key,
    required this.onClick,
    required this.selectedDate,
  });

  /// The currently selected date to be displayed.
  final DateTime selectedDate;

  /// The callback function to be triggered when the button is clicked.
  final void Function() onClick;
  
  @override
  State<DateSelectorButton> createState() => _DateSelectorButtonState();
}

class _DateSelectorButtonState extends State<DateSelectorButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
        ),
      ),
      child: TextButton(
        // When pressed, triggers the onClick callback passed from the parent widget.
        onPressed: widget.onClick,
        // Applies styling to the button from the current theme.
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.bodyLarge,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          alignment: Alignment.centerLeft,
        ),
        // Displays the formatted date as the button's child text.
        child: Text(formatter.format(widget.selectedDate)),
      ),
    );
  }
}
