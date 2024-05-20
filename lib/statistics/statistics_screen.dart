import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/services/helper_fucntions.dart';
import 'package:money_manager/statistics/cubit/statistics_cubit.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTimeRange _incomePieChartRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now());

  DateTimeRange _expensePieChartRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now());

  DateTimeRange _expenseLineChartRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now());

  DateTimeRange _incomeLineChartRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now());

  Widget _builLineChart(
      List<LineChartData> lineChartData,
      DateTimeRange dateTimeRange,
      ValueChanged<DateTimeRange> onDataTimeChanged) {
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
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  _presentDateRangePicker((value) {
                    onDataTimeChanged(value);
                  }, dateTimeRange);
                },
                icon: const Icon(Icons.calendar_month),
              ),
            ),
            lineChartData.isEmpty
                ? Center(
                    child: Text(
                      "Add data to see line chart",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
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
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(
      List<PieChartData> pieChartData,
      DateTimeRange dateTimeRange,
      ValueChanged<DateTimeRange> onDataTimeChanged) {
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
                      _presentDateRangePicker((value) {
                        onDataTimeChanged(value);
                      }, dateTimeRange);
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

  void _presentDateRangePicker(
      ValueChanged onSelectedChanged, selectedRange) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDateRange = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDateRange: selectedRange,
      firstDate: firstDate,
      lastDate: now,
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(),
        child: child!,
      ),
    );
    setState(() {
      if (pickedDateRange != null) {
        selectedRange = pickedDateRange;
        onSelectedChanged(pickedDateRange);
      }
    });
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
                    current is TabsAccountsLoaded ||
                    current is TabsTransactionAdded) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is TabsTransactionDeleted ||
                    state is TabsAccountsLoaded ||
                    state is TabsTransactionAdded) {
                  BlocProvider.of<StatisticsCubit>(context).loadRecords(
                    incomeLineChartRange: _incomeLineChartRange,
                    expenseLineChartRange: _expenseLineChartRange,
                    incomePieChartRange: _incomePieChartRange,
                    expensePieChartRange: _expensePieChartRange,
                  );
                  return BlocBuilder<StatisticsCubit, StatisticsState>(
                      builder: (context, state) {
                    if (state is StatisticsInitial) {
                      BlocProvider.of<StatisticsCubit>(context).loadRecords(
                        incomeLineChartRange: _incomeLineChartRange,
                        expenseLineChartRange: _expenseLineChartRange,
                        incomePieChartRange: _incomePieChartRange,
                        expensePieChartRange: _expensePieChartRange,
                      );
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
                                  _buildPieChart(
                                    state.pieChartIncome,
                                    _incomePieChartRange,
                                    (value) {
                                      setState(() {
                                        _incomePieChartRange = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 50),
                                  _builLineChart(state.lineChartIncome,
                                      _incomeLineChartRange, (value) {
                                      setState(() {
                                        _incomeLineChartRange = value;
                                      });
                                    },),
                                ],
                              ),
                              ListView(
                                children: [
                                  _buildPieChart(state.pieChartExpense,
                                      _expensePieChartRange, (value) {
                                      setState(() {
                                        _expensePieChartRange = value;
                                      });
                                    },),
                                  const SizedBox(height: 50),
                                  _builLineChart(state.lineChartExpense,
                                      _expenseLineChartRange, (value){
                                        setState(() {
                                          _expenseLineChartRange = value;
                                        });
                                      }),
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
