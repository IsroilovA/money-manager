import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/statistics/cubit/statistics_cubit.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Widget _builLineChart(List<LineChartData> lineChartData) {
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
    return lineChartData.isEmpty
        ? const Center(
            child: Text("Add data to see statistics"),
          )
        : Card(
            elevation: 1,
            child: SfCartesianChart(
              margin: const EdgeInsets.all(10),
              tooltipBehavior: toolTipBehavior,
              primaryYAxis: const NumericAxis(
                labelFormat: '{value} \$',
              ),
              series: <LineSeries<LineChartData, int>>[
                LineSeries<LineChartData, int>(
                  dataSource: lineChartData,
                  xValueMapper: (LineChartData data, _) => data.date.day,
                  yValueMapper: (LineChartData data, _) => data.amount,
                  markerSettings: const MarkerSettings(isVisible: true),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                  ),
                  enableTooltip: true,
                )
              ],
            ),
          );
  }

  Widget _buildPieChart(List<PieChartData> pieChartData) {
    var toolTipBehavior = TooltipBehavior(enable: true);
    return pieChartData.isEmpty
        ? const Center(
            child: Text("Add data to see statistics"),
          )
        : Card(
            elevation: 1,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 1,
                  child: SfCircularChart(
                    tooltipBehavior: toolTipBehavior,
                    legend: const Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                    ),
                    series: [
                      PieSeries<PieChartData, String>(
                        enableTooltip: true,
                        dataSource: pieChartData,
                        xValueMapper: (PieChartData data, _) => data.category,
                        yValueMapper: (PieChartData data, _) => data.amount,
                        pointColorMapper: (PieChartData data, _) => data.color,
                        dataLabelMapper: (PieChartData data, _) =>
                            data.category,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside),
                        explode: true,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
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
                              "${(pieChartData[index].amount / totalAmount).toStringAsFixed(1)} %",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                        trailing: Text("${pieChartData[index].amount}"),
                      );
                    },
                  ),
                )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          const TabBar(
            //make the indicator the size of the full tab
            indicatorSize: TabBarIndicatorSize.label,
            //remove deivder
            dividerHeight: 2,
            tabs: [
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Expense',
              ),
            ],
          ),
          BlocProvider(
            create: (context) => StatisticsCubit(),
            child: BlocBuilder<TabsCubit, TabsState>(
              buildWhen: (previous, current) {
                if (current is TabsTransactionDeleted ||
                    current is TabsLoaded ||
                    current is TabsTransactionAdded) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is TabsTransactionDeleted ||
                    state is TabsLoaded ||
                    state is TabsTransactionAdded) {
                  BlocProvider.of<StatisticsCubit>(context).loadRecords();
                  return BlocBuilder<StatisticsCubit, StatisticsState>(
                      builder: (context, state) {
                    if (state is StatisticsInitial) {
                      BlocProvider.of<StatisticsCubit>(context).loadRecords();
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is StatisticsDataLoaded) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TabBarView(
                            children: [
                              ListView(
                                children: [
                                  _buildPieChart(state.pieChartIncome),
                                  const SizedBox(height: 50),
                                  _builLineChart(state.lineChartIncome),
                                ],
                              ),
                              ListView(
                                children: [
                                  _buildPieChart(state.pieChartExpense),
                                  const SizedBox(height: 50),
                                  _builLineChart(state.lineChartExpense),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } else if (state is StatisticsError) {
                      return Center(
                        child: Text(
                          "Error: ${state.message}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      );
                    } else {
                      return const Center(child: Text("Something is wrond"));
                    }
                  });
                } else {
                  return const Text("error");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
