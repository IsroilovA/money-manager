import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_transaction/widgets/form_list_tile.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/services/database_helper.dart';
import 'package:money_manager/services/helper_fucntions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';
import 'package:money_manager/tabs/tabs.dart';

class AddEditAccountScreen extends StatefulWidget {
  const AddEditAccountScreen({super.key, this.account});

  final Account? account;

  @override
  State<AddEditAccountScreen> createState() {
    return _AddEditAccountScreenState();
  }
}

class _AddEditAccountScreenState extends State<AddEditAccountScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  void _saveAccount() async {
    final enteredBalance = double.tryParse(_balanceController.text);
    final amountIsInvalid = enteredBalance == null;
    final nameEntered = _nameController.text.trim().isEmpty;
    Account newAccount;
    if (amountIsInvalid) {
      showFormAlertDialog(context, "enter a valid amount");
      return;
    } else if (nameEntered) {
      showFormAlertDialog(context, "Enter the name of the account");
      return;
    }

    final hasPagePushed = Navigator.of(context).canPop();

    if (widget.account != null) {
      newAccount = Account(
          id: widget.account!.id,
          balance: enteredBalance,
          name: _nameController.text);
    } else {
      newAccount = Account(balance: enteredBalance, name: _nameController.text);
    }
    if (hasPagePushed) {
      Navigator.of(context).pop(newAccount);
    } else {
      await DatabaseHelper.addAccount(newAccount);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => TabsCubit(),
            child: const TabsScreen(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    if (widget.account != null) {
      _nameController.text = widget.account!.name;
      _balanceController.text = widget.account!.balance.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: widget.account == null
            ? const Text('New account')
            : const Text("Edit account"),
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
              enableInteractiveSelection: false,
              showCursor: false,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _balanceController,
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final RegExp regExp = RegExp(r'^-?\d*\.?\d{0,2}$');
                  if (newValue.text.isEmpty) {
                    return newValue.copyWith(text: '');
                  }
                  if (regExp.hasMatch(newValue.text)) {
                    return newValue;
                  } else if (!oldValue.text.contains('-') &&
                      newValue.text.contains('-')) {
                    return newValue.copyWith(
                        text:
                            '-${newValue.text.substring(0, newValue.text.length - 1)}');
                  } else if (!newValue.text.contains(" ") &&
                      oldValue.text.contains('-')) {
                    String newText =
                        newValue.text.substring(1, newValue.text.length - 1);
                    return newValue.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                  return oldValue;
                }),
              ],
              maxLines: 1,
              maxLength: 20,
              decoration: const InputDecoration(
                prefixText: 'UZS ',
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
