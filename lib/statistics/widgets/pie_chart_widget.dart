import 'package:flutter/material.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:money_manager/statistics/cubit/statistics_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWidget extends StatelessWidget {
  final List<PieChartData> pieChartData;
  final DateTimeRange dateTimeRange;
  final ValueChanged<DateTimeRange> onDataTimeChanged;
  final Function(
    ValueChanged<DateTimeRange>,
    DateTimeRange,
  ) presentDateRangePicker;

  const PieChartWidget({
    super.key,
    required this.pieChartData,
    required this.dateTimeRange,
    required this.onDataTimeChanged,
    required this.presentDateRangePicker,
  });

  @override
  Widget build(BuildContext context) {
    var toolTipBehavior = TooltipBehavior(enable: true);
    return Card(
      elevation: 1,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 2,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      presentDateRangePicker(onDataTimeChanged, dateTimeRange);
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
                pieChartData.isEmpty
                    ? Center(
                        child: Text(
                          "No data for selected range",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      )
                    : SfCircularChart(
                        tooltipBehavior: toolTipBehavior,
                        legend: const Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        series: [
                          PieSeries<PieChartData, String>(
                            enableTooltip: true,
                            dataSource: pieChartData,
                            xValueMapper: (PieChartData data, _) =>
                                data.category,
                            yValueMapper: (PieChartData data, _) => data.amount,
                            pointColorMapper: (PieChartData data, _) =>
                                data.color,
                            dataLabelMapper: (PieChartData data, _) =>
                                data.category,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside),
                            explode: true,
                          )
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            elevation: 2,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: pieChartData.length,
              itemBuilder: (context, index) {
                double totalAmount = 0.0;
                for (var element in pieChartData) {
                  totalAmount += element.amount;
                }
                return ListTile(
                  leading: Container(
                    height: 30,
                    width: 50,
                    color: pieChartData[index].color,
                    child: Center(
                      child: Text(
                        "${(pieChartData[index].amount / totalAmount * 100).toStringAsFixed(1)}%",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(pieChartData[index].icon),
                      const SizedBox(width: 8),
                      Text(pieChartData[index].category)
                    ],
                  ),
                  trailing: Text(
                      currencyFormatter.format(pieChartData[index].amount)),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
