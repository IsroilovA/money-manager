import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/add_transaction/widgets/form_list_tile.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/services/helper_fucntions.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key, this.goal});

  final Goal? goal;
  @override
  State<AddGoalScreen> createState() {
    return _AddGoalScreenState();
  }
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _nameController = TextEditingController();
  final _currentBalanceController = TextEditingController();
  final _goalBalanceController = TextEditingController();
  void _saveGoal() async {
    final enteredCurrentBalance =
        double.tryParse(_currentBalanceController.text);
    final enteredGoalBalance = double.tryParse(_goalBalanceController.text);
    final currentBalanceIsInvalid =
        enteredCurrentBalance == null || enteredCurrentBalance <= 0;
    final enteredBalanceIsInvalid =
        enteredGoalBalance == null || enteredGoalBalance <= 0;
    final nameEntered = _nameController.text.trim().isEmpty;
    Goal newGoal;
    if (currentBalanceIsInvalid || enteredBalanceIsInvalid) {
      showFormAlertDialog(context, "enter a valid amount");
      return;
    } else if (nameEntered) {
      showFormAlertDialog(context, "Enter the name of the goal");
      return;
    }
    if (widget.goal != null) {
      newGoal = Goal(
        id: widget.goal!.id,
        name: _nameController.text,
        currentBalance: enteredCurrentBalance,
        goalBalance: enteredGoalBalance,
      );
    } else {
      newGoal = Goal(
          currentBalance: enteredCurrentBalance,
          goalBalance: enteredGoalBalance,
          name: _nameController.text);
    }

    Navigator.of(context).pop(newGoal);
  }

  @override
  void initState() {
    if (widget.goal != null) {
      _nameController.text = widget.goal!.name;
      _currentBalanceController.text = widget.goal!.currentBalance.toString();
      _goalBalanceController.text = widget.goal!.goalBalance.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Goal'),
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
            leadingText: "Current Balance",
            titleWidget: TextField(
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _currentBalanceController,
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
          FormListTile(
            leadingText: "Goal Balance",
            titleWidget: TextField(
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _goalBalanceController,
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
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _saveGoal,
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
