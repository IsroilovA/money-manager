import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(locale: "uz_US");

final dateFormatter = DateFormat.yMd();

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String insertComas(String text) {
  String newText = '';
  int indexOfDot = text.indexOf('.');
  if (indexOfDot != -1) {
    newText = text.substring(indexOfDot, text.length);
    for (var i = 0; i < indexOfDot; i++) {
      if (i != 0 && i % 3 == 0) {
        newText = ',$newText';
      }
      newText =
          text[text.length - i - 1 - (text.length - indexOfDot)] + newText;
    }
    return newText;
  }
  for (var i = 0; i < text.length; i++) {
    if (i != 0 && i % 3 == 0) {
      newText = ',$newText';
    }
    newText = text[text.length - i - 1] + newText;
  }
  return newText;
}

void showWarningAlertDialog(
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
        titleTextStyle:
            TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onSurface),
        contentTextStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.onSurface),
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
