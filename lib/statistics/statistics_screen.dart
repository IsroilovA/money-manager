import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    var toolTipBehavior = TooltipBehavior(enable: true);
    return lineChartData.isEmpty
        ? const Center(
            child: Text("Add data to see statistics"),
          )
        : SfCartesianChart(
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
          );
  }

  Widget _buildPieChart(List<PieChartData> pieChartData) {
    var toolTipBehavior = TooltipBehavior(enable: true);
    return pieChartData.isEmpty
        ? const Center(
            child: Text("Add data to see statistics"),
          )
        : SfCircularChart(
            tooltipBehavior: toolTipBehavior,
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              // legendItemBuilder: (legendText, series, point, seriesIndex) {
              //   return ListView.builder(
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: pieChartData.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         leading: Icon(categoryIcons[legendText]),
              //       );
              //     },
              //   );
              // },
            ),
            series: [
              PieSeries<PieChartData, String>(
                enableTooltip: true,
                dataSource: pieChartData,
                xValueMapper: (PieChartData data, _) => data.category,
                yValueMapper: (PieChartData data, _) => data.amount,
                dataLabelMapper: (PieChartData data, _) => data.category,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside),
                explode: true,
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          TabBar(
            //make the indicator the size of the full tab
            indicatorSize: TabBarIndicatorSize.tab,
            //remove deivder
            dividerHeight: 0,
            indicator: BoxDecoration(
              border: Border.all(
                  width: 1, color: Theme.of(context).colorScheme.primary),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            tabs: const [
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
                        child: TabBarView(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildPieChart(state.pieChartIncome),
                                _builLineChart(state.lineChartIncome),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildPieChart(state.pieChartExpense),
                                _builLineChart(state.lineChartExpense),
                              ],
                            )
                          ],
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
