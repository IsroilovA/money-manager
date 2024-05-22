import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Currency formatter for the locale "uz_US"
final currencyFormatter = NumberFormat.currency(locale: "uz_US");

// Date formatter for year-month-day format
final dateFormatter = DateFormat.yMd();

// Extension on String to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

// Formatter to allow only positive currency values with two decimal places
class PositiveCurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r'^\d*\.?\d{0,2}$');
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    if (newValue.text.length <= 20) {
      if (regExp.hasMatch(newValue.text.replaceAll(',', ''))) {
        String newText = insertCommas(newValue.text.replaceAll(',', ''));
        return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
    return oldValue;
  }
}

// Formatter to allow negative and positive currency values with two decimal places
class NegativeCurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r'^-?\d*\.?\d{0,2}$');
    String newText;
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    if (newValue.text.length <= 20) {
      if (regExp.hasMatch(newValue.text.replaceAll(',', ''))) {
        newText = insertCommas(newValue.text.replaceAll(RegExp(r'[,\-]'), ''));
        if (newValue.text.contains('-')) {
          newText = '-$newText';
        }
        return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      } else if (!oldValue.text.contains('-') && newValue.text.contains('-')) {
        newText = insertCommas(newValue.text.replaceAll(RegExp(r'[,\-]'), ''));
        return newValue.copyWith(
          text: '-$newText',
          selection: TextSelection.collapsed(offset: newText.length),
        );
      } else if (!newValue.text.contains(" ") && oldValue.text.contains('-')) {
        newText = insertCommas(newValue.text.replaceAll(RegExp(r'[,\-]'), ''));
        return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
    return oldValue;
  }
}

// Helper function to insert commas into a numerical string
String insertCommas(String text) {
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

// Function to show a warning alert dialog
void showWarningAlertDialog({
  required BuildContext context,
  required String text,
  required void Function() onYesClicked,
}) {
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

// Function to show an alert dialog for form validation
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