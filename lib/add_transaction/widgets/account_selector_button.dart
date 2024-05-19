import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

class AccountSelectorButton extends StatefulWidget {
  const AccountSelectorButton({
    super.key,
    required this.onAccountChanged,
    this.selectedAccountId,
  });

  final ValueChanged<String> onAccountChanged;
  final String? selectedAccountId;

  @override
  State<AccountSelectorButton> createState() => _AccountSelectorButtonState();
}

class _AccountSelectorButtonState extends State<AccountSelectorButton> {
  Account? _account;

  void _openBottomSheet(List<Account> accounts) {
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
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
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
                    for (final account in accounts)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _account = account;
                          });
                          widget.onAccountChanged(account.id);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            border: Border.all(
                              width: 0.3,
                            ),
                          ),
                          child: Center(
                              child: Text(
                            account.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant),
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
    final accounts = context.select((TabsCubit cubit) => cubit.accounts);
    if (widget.selectedAccountId != null) {
      _account = accounts
          .firstWhere((account) => account.id == widget.selectedAccountId);
    }
    Widget content = const Text("");
    if (_account != null) {
      content = Text(_account!.name);
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1.0,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
        ),
      ),
      child: TextButton(
          onPressed: () {
            _openBottomSheet(accounts);
          },
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
