import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_transaction/widgets/form_list_tile.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/services/database_helper.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';
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

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => TabsCubit(),
                child: const TabsScreen(),
              )),
    );
  }

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
          FormListTile(
            leadingText: "Name",
            titleWidget: TextField(
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              controller: _nameController,
              maxLines: 1,
              maxLength: 60,
            ),
          ),
          FormListTile(
            leadingText: "Amount",
            titleWidget: TextField(
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
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
