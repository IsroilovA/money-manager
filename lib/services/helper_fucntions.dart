import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(locale: "en_US", symbol: '\$');

final dateFormatter = DateFormat.yMd();

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

void showWarningAlertDialog (
    {required BuildContext context,
    required String text,
    required void Function() onYesClicked}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("Warning!"),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: onYesClicked,
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Invalid Input!"),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: onYesClicked,
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
  }
}

void showFormAlertDialog(BuildContext context, String text) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("Invalid Input!"),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Invalid Input!"),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }
}
