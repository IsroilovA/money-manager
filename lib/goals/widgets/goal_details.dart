import 'package:flutter/material.dart';
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
              // showDialog(context: context, builder:(context) {
              //   retr
              // },);
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
