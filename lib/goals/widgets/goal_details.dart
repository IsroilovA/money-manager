import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/data/models/goal.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GoalDetails extends StatelessWidget {
  const GoalDetails({super.key, required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Goal details"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                        Text(
                          "${goal.currentBalance / goal.goalBalance * 100} %",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${goal.currentBalance} / ${goal.goalBalance} \$",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () {
              final currentBalanceController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      "Add saved amount",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    children: [
                      TextField(
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        controller: currentBalanceController,
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
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 15),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Insert"),
                        ),
                      ])
                    ],
                  );
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: Size(width * 0.8, 0),
              textStyle: Theme.of(context).textTheme.titleMedium,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            child: const Text("Add saved amount"),
          )
        ],
      ),
    );
  }
}
