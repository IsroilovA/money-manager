import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/services/locator.dart';
import 'package:money_manager/services/money_manager_repository.dart';
import 'package:money_manager/statistics/cubit/statistics_cubit.dart';
import 'package:money_manager/statistics/widgets/line_chart_widget.dart';
import 'package:money_manager/statistics/widgets/pie_chart_widget.dart';
import 'package:money_manager/tabs/cubit/tabs_cubit.dart';

// Main screen for displaying statistical data using charts
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

  // Present date range picker dialog
  void _presentDateRangePicker(ValueChanged<DateTimeRange> onSelectedChanged,
      DateTimeRange selectedRange) async {
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
    if (pickedDateRange != null) {
      selectedRange = pickedDateRange;
      onSelectedChanged(pickedDateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
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
            create: (context) => StatisticsCubit(
                moneyManagerRepository: locator<MoneyManagerRepository>()),
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
                                  PieChartWidget(
                                    pieChartData: state.pieChartIncome,
                                    dateTimeRange: _incomePieChartRange,
                                    onDataTimeChanged: (value) {
                                      setState(() {
                                        _incomePieChartRange = value;
                                      });
                                    },
                                    presentDateRangePicker:
                                        _presentDateRangePicker,
                                  ),
                                  const SizedBox(height: 50),
                                  LineChartWidget(
                                    lineChartData: state.lineChartIncome,
                                    dateTimeRange: _incomeLineChartRange,
                                    onDataTimeChanged: (value) {
                                      setState(() {
                                        _incomeLineChartRange = value;
                                      });
                                    },
                                    presentDateRangePicker:
                                        _presentDateRangePicker,
                                  ),
                                ],
                              ),
                              ListView(
                                children: [
                                  PieChartWidget(
                                    pieChartData: state.pieChartExpense,
                                    dateTimeRange: _expensePieChartRange,
                                    onDataTimeChanged: (value) {
                                      setState(() {
                                        _expensePieChartRange = value;
                                      });
                                    },
                                    presentDateRangePicker:
                                        _presentDateRangePicker,
                                  ),
                                  const SizedBox(height: 50),
                                  LineChartWidget(
                                    lineChartData: state.lineChartExpense,
                                    dateTimeRange: _expenseLineChartRange,
                                    onDataTimeChanged: (value) {
                                      setState(() {
                                        _expenseLineChartRange = value;
                                      });
                                    },
                                    presentDateRangePicker:
                                        _presentDateRangePicker,
                                  ),
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
                      return const Center(child: Text("Something is wrong"));
                    }
                  });
                } else {
                  return const Text("Error");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
