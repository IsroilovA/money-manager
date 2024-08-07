import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/add_transaction/widgets/amount_text_field.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:money_manager/goals/cubit/goal_cubit.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GoalDetails extends StatelessWidget {
  const GoalDetails({super.key, required this.goal});
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    /// Confirms the deletion of the account and all related transactions.
    void confirmDeletion() {
      showWarningAlertDialog(
        context: context,
        text: "Are you sure you want to delete the Goal?",
        onYesClicked: () {
          // Delete the account and all related transactions
          BlocProvider.of<GoalCubit>(context).deleteGoal(goal);
          // Pop the confirmation dialog
          Navigator.pop(context);
          // Pop the account details screen
          Navigator.pop(context);
        },
      );
    }

    // Function to build the goal details screen
    Widget buildGoalDetailsScreen(Goal goal) {
      var width = MediaQuery.of(context).size.width;
      return Column(children: [
        // Gauge to show goal progress
        SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: goal.goalBalance + 1,
              startAngle: 270,
              endAngle: 270,
              showLabels: false,
              showTicks: false,
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display percentage of goal achieved
                      Text(
                        "${(goal.currentBalance / goal.goalBalance * 100).toStringAsFixed(1)} %",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 60,
                            ),
                      ),
                      const SizedBox(height: 20),
                      // Display current balance and goal balance
                      Text(
                        "${insertCommas(goal.currentBalance.toString())} / ${insertCommas(goal.goalBalance.toString())} UZS",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      )
                    ],
                  ),
                )
              ],
              pointers: <GaugePointer>[
                RangePointer(
                  value: goal.currentBalance,
                  width: 15,
                )
              ],
            )
          ],
        ),
        const SizedBox(height: 50),
        // Button to add or remove saved amount
        TextButton(
          onPressed: () async {
            double addedRemovedAmount = 0.0;
            await showDialog(
              context: context,
              builder: (context) {
                final amountController = TextEditingController();
                return SimpleDialog(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    "Add/Remove saved amount",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  children: [
                    // Input field for amount with formatter
                    AmountTextField(
                        amountController: amountController,
                        textInputFormatter: NegativeCurrencyInputFormatter()),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {
                          final enteredAmount = double.tryParse(
                              amountController.text.replaceAll(',', ''));
                          if (enteredAmount == null) {
                            showFormAlertDialog(
                                context, "Enter a valid amount");
                            return;
                          }
                          if (goal.currentBalance + enteredAmount >
                              goal.goalBalance) {
                            showFormAlertDialog(context,
                                "You added more than needed to meet the goal");
                            return;
                          } else if (enteredAmount < 0 &&
                              goal.currentBalance + enteredAmount < 0) {
                            showFormAlertDialog(context,
                                "You can't remove more amount than there is");
                            return;
                          }
                          addedRemovedAmount = enteredAmount;
                          Navigator.pop(context);
                        },
                        child: const Text("Insert"),
                      ),
                    ])
                  ],
                );
              },
            );
            if (addedRemovedAmount == 0) {
              return;
            }
            if (context.mounted) {
              BlocProvider.of<GoalCubit>(context)
                  .addAmount(goal, addedRemovedAmount);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            minimumSize: Size(width * 0.8, 0),
            textStyle: Theme.of(context).textTheme.titleMedium,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          child: const Text("Add/Remove saved amount"),
        )
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Goal details"),
        centerTitle: true,
        actions: [
          // Button to delete the goal
          IconButton(
            onPressed: confirmDeletion,
            icon: const Icon(Icons.delete),
          ),
          // Button to edit the goal
          IconButton(
            onPressed: () {
              BlocProvider.of<GoalCubit>(context).editGoal(context, goal.id);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: BlocBuilder<GoalCubit, GoalState>(
        buildWhen: (previous, current) {
          if (current is GoalEdited) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is GoalEdited) {
            return buildGoalDetailsScreen(state.updatedGoal);
          } else {
            return buildGoalDetailsScreen(goal);
          }
        },
      ),
    );
  }
}
