import 'package:flutter/material.dart';

class CustomInputButton extends StatelessWidget {
  const CustomInputButton({
    super.key,
    required this.selectedValue,
    required this.onClick,
  });

  final dynamic selectedValue;

  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black),
        ),
      ),
      child: TextButton(
        onPressed: onClick,
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.bodyLarge,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          alignment: Alignment.centerLeft,
        ),
        child: Text("$selectedValue"),
      ),
    );
  }
}
