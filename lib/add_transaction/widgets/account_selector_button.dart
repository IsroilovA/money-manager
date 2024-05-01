import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/services/database_helper.dart';

final formatter = DateFormat.yMd();

class AccountSelectorButton extends StatefulWidget {
  const AccountSelectorButton({
    super.key,
    required this.onAccountChanged,
  });

  final ValueChanged<Account> onAccountChanged;

  @override
  State<AccountSelectorButton> createState() => _AccountSelectorButtonState();
}

class _AccountSelectorButtonState extends State<AccountSelectorButton> {
  Account? _account;
  List<Account>? accounts;
  void _getAccounts() async {
    accounts = await DatabaseHelper.getAllAccounts();
  }

  void _openBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const ContinuousRectangleBorder(),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                  ),
                  children: [
                    for (final account in accounts!)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _account = account;
                          });
                          widget.onAccountChanged(account);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            border: Border.all(
                              width: 0.3,
                            ),
                          ),
                          child: Center(
                              child: Text(
                            account.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          )),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _getAccounts();
    Widget content = const Text("");
    if (_account != null) {
      content = Text(_account!.name);
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: TextButton(
          onPressed: _openBottomSheet,
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            alignment: Alignment.centerLeft,
          ),
          child: content),
    );
  }
}
