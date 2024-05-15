import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_transaction/widgets/form_list_tile.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/services/database_helper.dart';
import 'package:money_manager/services/helper_fucntions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';
import 'package:money_manager/tabs/tabs.dart';

class AddNewAccountScreen extends StatefulWidget {
  const AddNewAccountScreen({super.key});

  @override
  State<AddNewAccountScreen> createState() {
    return _AddNewAccountScreenState();
  }
}

class _AddNewAccountScreenState extends State<AddNewAccountScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  void _saveAccount() async {
    final enteredBalance = double.tryParse(_balanceController.text);
    final amountIsInvalid = enteredBalance == null || enteredBalance <= 0;
    final nameEntered = _nameController.text.trim().isEmpty;
    Account newAccount;
    if (amountIsInvalid) {
      showAlertDialog(context, "enter a valid amount");
      return;
    } else if (nameEntered) {
      showAlertDialog(context, "Enter the name of the account");
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
