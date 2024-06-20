import 'package:flutter/material.dart';
import 'package:money_manager/services/helper_functions.dart';
import 'package:money_manager/statistics/cubit/statistics_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatelessWidget {
  final List<LineChartData> lineChartData;
  final DateTimeRange dateTimeRange;
  final ValueChanged<DateTimeRange> onDataTimeChanged;
  final Function(
    ValueChanged<DateTimeRange>,
    DateTimeRange,
  ) presentDateRangePicker;

  const LineChartWidget({
    super.key,
    required this.lineChartData,
    required this.dateTimeRange,
    required this.onDataTimeChanged,
    required this.presentDateRangePicker,
  });

  @override
  Widget build(BuildContext context) {
    var toolTipBehavior = TooltipBehavior(
      enable: true,
      builder: (data, point, series, pointIndex, seriesIndex) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "${data.date.day}/${data.date.month}/${data.date.year}: ${currencyFormatter.format(data.amount)}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ],
          ),
        );
      },
    );
    return Card(
      elevation: 1,
      color: Theme.of(context).colorScheme.surfaceDim,
      child: Card(
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
            lineChartData.isEmpty
                ? Center(
                    child: Text(
                      "No data for selected range",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  )
                : SfCartesianChart(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    tooltipBehavior: toolTipBehavior,
                    primaryYAxis: const NumericAxis(
                      labelFormat: '{value} \$',
                    ),
                    primaryXAxis: const DateTimeAxis(),
                    series: <LineSeries<LineChartData, DateTime>>[
                      LineSeries<LineChartData, DateTime>(
                        dataSource: lineChartData,
                        xValueMapper: (LineChartData data, _) => data.date,
                        yValueMapper: (LineChartData data, _) => data.amount,
                        markerSettings: const MarkerSettings(isVisible: true),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                        enableTooltip: true,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
