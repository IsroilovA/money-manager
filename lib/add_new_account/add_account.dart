import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/services/database_helper.dart';
import 'package:money_manager/tabs/tabs.dart';

class AddNewAccount extends StatefulWidget {
  const AddNewAccount({super.key});

  @override
  State<AddNewAccount> createState() {
    return _AddNewAccountState();
  }
}

class _AddNewAccountState extends State<AddNewAccount> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  void _showDialog(String text) {
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

  void _saveAccount() async {
    final enteredBalance = double.tryParse(_balanceController.text);
    final amountIsInvalid = enteredBalance == null || enteredBalance <= 0;
    final nameEntered = _nameController.text.trim().isEmpty;
    Account newAccount;
    if (amountIsInvalid) {
      _showDialog("enter a valid amount");
      return;
    } else if (nameEntered) {
      _showDialog("Enter the name of the account");
      return;
    }
    newAccount = Account(balance: enteredBalance, name: _nameController.text);

    await DatabaseHelper.addAccount(newAccount);

    List<Account>? accounts = await DatabaseHelper.getAllAccounts();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const TabsScreen()),
    );
  }

  // void _getAccounts() async {
  //   accounts = await DatabaseHelper.getAllAccounts();
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Text("Name"),
            minLeadingWidth: width / 5,
            title: TextField(
              controller: _nameController,
              maxLines: 1,
              maxLength: 60,
            ),
          ),
          ListTile(
            leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Text('Amount'),
            minLeadingWidth: width / 5,
            title: TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _balanceController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}'),
                ),
              ],
              maxLines: 1,
              maxLength: 20,
              decoration: const InputDecoration(
                prefixText: '\$ ',
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _saveAccount,
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: Size(width * 2 / 3, 0),
              textStyle: Theme.of(context).textTheme.titleMedium,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            child: const Text("Save"),
          )
        ],
      ),
    );
  }
}
