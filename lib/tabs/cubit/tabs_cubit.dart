import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_account/add_edit_account_screen.dart';
import 'package:money_manager/add_transaction/add_edit_transaction_screen.dart';
import 'package:money_manager/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:money_manager/data/models/account.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/services/money_manager_repository.dart';

part 'tabs_state.dart';

// Cubit for managing the state of the tabs in the application
class TabsCubit extends Cubit<TabsState> {
  TabsCubit({required MoneyManagerRepository moneyManagerRepository})
      : _moneyManagerRepository = moneyManagerRepository,
        super(TabsInitial());

  final MoneyManagerRepository _moneyManagerRepository;

  int pageIndex = 0;
  List<Account> accounts = [];

  // Fetch the balance of a specific account by its ID
  Future<double> getAccountBalance(String id) async {
    return (await _moneyManagerRepository.getAccountById(id)).balance;
  }

  // Load all accounts from the database and update the state
  void loadAccounts() async {
    try {
      final receivedAccounts = await _moneyManagerRepository.getAllAccounts();
      if (receivedAccounts != null) {
        accounts = receivedAccounts;
        emit(TabsAccountsLoaded(accounts));
      } else {
        emit(TabsNoAccounts());
      }
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  // Select a page in the tabs and update the state
  void selectPage(int index) async {
    pageIndex = index;
    emit(TabsPageChanged(index));
  }

  // Delete a transaction from the database and update the state
  void deleteTransaction(TransactionRecord transactionRecord) async {
    emit(TabsLoading());
    try {
      await _moneyManagerRepository.deleteTransactionRecord(transactionRecord);
      emit(TabsTransactionDeleted(transactionRecord));
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  // Add a transaction back to the database and update the state
  void addTransactionBack(TransactionRecord transactionRecord) async {
    emit(TabsLoading());
    try {
      if (transactionRecord.recordType == RecordType.transfer) {
        await _moneyManagerRepository.addTransferTransaction(transactionRecord);
      } else {
        await _moneyManagerRepository.addTransactionRecord(transactionRecord);
      }
      emit(TabsTransactionAdded(pageIndex));
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  // Edit an existing transaction and update the state
  void editTransaction(
      BuildContext context, TransactionRecord initialTransactionRecord) async {
    final editedTransaction =
        await Navigator.of(context).push<TransactionRecord>(
      MaterialPageRoute(
        builder: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<TabsCubit>(context),
            ),
            BlocProvider(
              create: (context) => AddTransactionCubit(),
            ),
          ],
          child:
              AddEditTransaction(transactionRecord: initialTransactionRecord),
        ),
      ),
    );
    if (editedTransaction == null) {
      return;
    }
    var updatedTransaction = TransactionRecord(
      date: editedTransaction.date,
      note: editedTransaction.note,
      amount: editedTransaction.amount,
      recordType: editedTransaction.recordType,
      accountId: editedTransaction.accountId,
      expenseCategory: editedTransaction.expenseCategory,
      incomeCategory: editedTransaction.incomeCategory,
      transferAccount2Id: editedTransaction.transferAccount2Id,
      id: initialTransactionRecord.id,
    );
    try {
      await _moneyManagerRepository
          .deleteTransactionRecord(initialTransactionRecord);
      if (updatedTransaction.recordType == RecordType.transfer) {
        await _moneyManagerRepository
            .addTransferTransaction(updatedTransaction);
      } else {
        await _moneyManagerRepository.addTransactionRecord(updatedTransaction);
      }
      emit(TabsTransactionAdded(0));
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  // Add a new transaction and update the state
  void addTransaction(BuildContext context, int pageIndex) async {
    final newTransaction = await Navigator.of(context).push<TransactionRecord>(
      MaterialPageRoute(
        builder: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<TabsCubit>(context),
            ),
            BlocProvider(
              create: (context) => AddTransactionCubit(),
            ),
          ],
          child: const AddEditTransaction(),
        ),
      ),
    );
    if (newTransaction == null) {
      return;
    }
    try {
      if (newTransaction.recordType == RecordType.transfer) {
        await _moneyManagerRepository.addTransferTransaction(newTransaction);
      } else {
        await _moneyManagerRepository.addTransactionRecord(newTransaction);
      }
      emit(TabsTransactionAdded(pageIndex));
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }

  // Add a new account and update the state
  void addAccount(BuildContext context) async {
    final newAccount = await Navigator.of(context).push<Account>(
      MaterialPageRoute(
        builder: (ctx) => const AddEditAccountScreen(),
      ),
    );
    if (newAccount == null) {
      return;
    }
    try {
      await _moneyManagerRepository.addAccount(newAccount);
      emit(TabsInitial());
    } catch (e) {
      emit(TabsError(e.toString()));
    }
  }
}
