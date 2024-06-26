import 'package:flutter/material.dart';
import 'package:money_manager/add_transaction/widgets/account_selector_button.dart';
import 'package:money_manager/add_transaction/widgets/amount_text_field.dart';
import 'package:money_manager/add_transaction/widgets/form_list_tile.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/add_transaction/widgets/category_selector_button.dart';
import 'package:money_manager/add_transaction/widgets/date_selector_button.dart';
import 'package:money_manager/services/helper_functions.dart';

/// A form widget for adding and editing transactions.
class TransactionForm extends StatefulWidget {
  const TransactionForm({
    super.key,
    required this.recordType,
    this.transactionRecord,
  });

  /// The type of record (expense, income, transfer).
  final RecordType recordType;

  /// The transaction record being edited, if any.
  final TransactionRecord? transactionRecord;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late RecordType _recordType;
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExpenseCategory? _expenseCategory;
  IncomeCategory? _incomeCategory;
  String? _accountId;
  String? _transferAccount2Id;

  @override
  void initState() {
    super.initState();
    // Initialize form fields if editing an existing transaction.
    if (widget.transactionRecord != null) {
      _selectedDate = widget.transactionRecord!.date;
      _accountId = widget.transactionRecord!.accountId;
      _amountController.text =
          insertCommas(widget.transactionRecord!.amount.toString());
      _recordType = widget.transactionRecord!.recordType;
      _noteController.text = widget.transactionRecord!.note ?? "";
      _expenseCategory = widget.transactionRecord!.expenseCategory;
      _incomeCategory = widget.transactionRecord!.incomeCategory;
      _transferAccount2Id = widget.transactionRecord!.transferAccount2Id;
    }
  }

  /// Presents a date picker to select a transaction date.
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      if (pickedDate != null) {
        _selectedDate = pickedDate;
      }
    });
  }

  /// Saves the transaction and performs validation checks.
  void _saveTransaction() {
    final enteredAmount =
        double.tryParse(_amountController.text.replaceAll(",", ''));
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    final noteNotEntered = _noteController.text.trim().isEmpty;
    TransactionRecord newRecord;
    if (amountIsInvalid) {
      showFormAlertDialog(context, "Enter a valid amount");
      return;
    }

    if (_recordType == RecordType.transfer) {
      if (_accountId == null || _transferAccount2Id == null) {
        showFormAlertDialog(context, "Select both accounts");
        return;
      } else if (_accountId == _transferAccount2Id) {
        showFormAlertDialog(context, "Select two different accounts");
        return;
      }
      if (noteNotEntered) {
        newRecord = TransactionRecord(
          transferAccount2Id: _transferAccount2Id,
          accountId: _accountId!,
          date: _selectedDate,
          amount: enteredAmount,
          recordType: _recordType,
        );
      } else {
        newRecord = TransactionRecord(
            transferAccount2Id: _transferAccount2Id,
            accountId: _accountId!,
            date: _selectedDate,
            amount: enteredAmount,
            recordType: _recordType,
            note: _noteController.text);
      }
    } else {
      if (_expenseCategory == null && _incomeCategory == null) {
        showFormAlertDialog(context, "Select the category");
        return;
      } else if (_accountId == null) {
        showFormAlertDialog(context, "Select account");
        return;
      }

      if (_expenseCategory != null) {
        if (noteNotEntered) {
          newRecord = TransactionRecord(
              accountId: _accountId!,
              date: _selectedDate,
              amount: enteredAmount,
              recordType: _recordType,
              expenseCategory: _expenseCategory);
        } else {
          newRecord = TransactionRecord(
              accountId: _accountId!,
              date: _selectedDate,
              amount: enteredAmount,
              recordType: _recordType,
              expenseCategory: _expenseCategory,
              note: _noteController.text);
        }
      } else {
        if (noteNotEntered) {
          newRecord = TransactionRecord(
              accountId: _accountId!,
              date: _selectedDate,
              amount: enteredAmount,
              recordType: _recordType,
              incomeCategory: _incomeCategory);
        } else {
          newRecord = TransactionRecord(
              accountId: _accountId!,
              date: _selectedDate,
              amount: enteredAmount,
              recordType: _recordType,
              incomeCategory: _incomeCategory,
              note: _noteController.text);
        }
      }
    }
    Navigator.of(context).pop(newRecord);
  }

  @override
  Widget build(BuildContext context) {
    _recordType = widget.recordType;
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Form list tile for selecting the date.
          FormListTile(
            leadingText: "Date",
            titleWidget: DateSelectorButton(
              onClick: _presentDatePicker,
              selectedDate: _selectedDate,
            ),
          ),
          // Form list tile for entering the amount.
          FormListTile(
            leadingText: "Amount",
            titleWidget: AmountTextField(
              amountController: _amountController,
              textInputFormatter: PositiveCurrencyInputFormatter(),
            ),
          ),
          // Form list tile for selecting the account.
          FormListTile(
            leadingText: _recordType == RecordType.transfer
                ? "Account Sender"
                : "Account",
            titleWidget: AccountSelectorButton(
              selectedAccountId: _accountId,
              onAccountChanged: (value) {
                setState(() {
                  _accountId = value;
                });
              },
            ),
          ),
          // Form list tile for selecting the receiver account in case of transfer.
          _recordType == RecordType.transfer
              ? FormListTile(
                  leadingText: "Account Receiver",
                  titleWidget: AccountSelectorButton(
                    selectedAccountId: _transferAccount2Id,
                    onAccountChanged: (value) {
                      setState(() {
                        _transferAccount2Id = value;
                      });
                    },
                  ),
                )
              : FormListTile(
                  leadingText: "Category",
                  titleWidget: CategorySelectorButton(
                    recordType: _recordType,
                    selectedCategory: _recordType == RecordType.income
                        ? _incomeCategory
                        : _expenseCategory,
                    onExpenseChanged: (value) {
                      _incomeCategory = null;
                      _expenseCategory = value;
                    },
                    onIncomeChanged: (value) {
                      _expenseCategory = null;
                      _incomeCategory = value;
                    },
                  ),
                ),
          // Form list tile for entering a note.
          FormListTile(
            leadingText: "Note",
            titleWidget: TextField(
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              controller: _noteController,
              maxLines: 1,
              maxLength: 60,
            ),
          ),
          // Row of buttons for saving or canceling the transaction.
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _saveTransaction,
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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: Theme.of(context).colorScheme.primary),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                child: const Text('Cancel'),
              )
            ],
          )
        ],
      ),
    );
  }
}