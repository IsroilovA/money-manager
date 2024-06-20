import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_transaction/widgets/amount_text_field.dart';
import 'package:money_manager/add_transaction/widgets/form_list_tile.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/services/database_helper.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';
import 'package:money_manager/tabs/tabs.dart';

/// A screen for adding or editing an account.
class AddEditAccountScreen extends StatefulWidget {
  const AddEditAccountScreen({super.key, this.account});

  /// The account to be edited, if any.
  final Account? account;

  @override
  State<AddEditAccountScreen> createState() {
    return _AddEditAccountScreenState();
  }
}

class _AddEditAccountScreenState extends State<AddEditAccountScreen> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  /// Saves the account and performs validation checks.
  void _saveAccount() async {
    final enteredBalance =
        double.tryParse(_balanceController.text.replaceAll(',', ''));
    final amountIsInvalid = enteredBalance == null;
    final nameNotEntered = _nameController.text.trim().isEmpty;
    Account newAccount;
    if (amountIsInvalid) {
      showFormAlertDialog(context, "Enter a valid amount");
      return;
    } else if (nameNotEntered) {
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
      await MoneyManagerRepository.addAccount(newAccount);
      // ignore: use_build_context_synchronously
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
    super.initState();
    // Initialize form fields if editing an existing account.
    if (widget.account != null) {
      _nameController.text = widget.account!.name;
      _balanceController.text =
          insertCommas(widget.account!.balance.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: widget.account == null
            ? const Text('New Account')
            : const Text("Edit Account"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Form list tile for entering the account name.
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
          // Form list tile for entering the account balance.
          FormListTile(
            leadingText: "Amount",
            titleWidget: AmountTextField(
              amountController: _balanceController,
              textInputFormatter: NegativeCurrencyInputFormatter(),
            ),
          ),
          const SizedBox(height: 20),
          // Button to save the account.
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
          ),
        ],
      ),
    );
  }
}
