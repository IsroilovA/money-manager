import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormListTile extends StatelessWidget {
  const FormListTile({
    super.key,
    required this.leadingText,
    required this.titleWidget,
  });

  final String leadingText;
  final Widget titleWidget;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListTile(
        leadingAndTrailingTextStyle:
            Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
        leading: Text(leadingText),
        minLeadingWidth: width / 5,
        title: titleWidget);
  }
}
