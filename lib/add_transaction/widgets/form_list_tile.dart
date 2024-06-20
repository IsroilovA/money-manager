import 'package:flutter/material.dart';

/// A custom list tile widget for forms, displaying a leading text and a title widget.
class FormListTile extends StatelessWidget {
  const FormListTile({
    super.key,
    required this.leadingText,
    required this.titleWidget,
  });
  /// The text displayed at the leading position of the list tile.
  final String leadingText;
  /// The widget displayed as the title of the list tile.
  final Widget titleWidget;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListTile(
      // Sets the text style for the leading and trailing text.
      leadingAndTrailingTextStyle:
          Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
      // Displays the leading text.
      leading: Text(leadingText),
      // Sets a minimum width for the leading widget.
      minLeadingWidth: width / 5,
      // Displays the title widget.
      title: titleWidget,
    );
  }
}
