import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/data/models/transaction_record.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int touchedIndex = -1;

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
            create: (context) => HomeCubit(),
            child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
              BlocProvider.of<HomeCubit>(context).loadTransactions();
              if (state is HomeTransactionsLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is HomeNoTransactions) {
                return const Center(
                  child: Text("No data"),
                );
              } else if (state is HomeTransactionsLoaded) {
                return Expanded(
                  child: TabBarView(
                    children: [
                      buildIncomeStatisticsScreen(state.transactionRecords),
                      buildExpenseStatisticsScreen(state.transactionRecords)
                    ],
                  ),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Text(
                    "Error: ${state.message}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              } else {
                return const Center(child: Text("Something is wrond"));
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget buildExpenseStatisticsScreen(
      List<TransactionRecord> transactionRecords) {
    Widget content = const Center(child: Text("No records yet"));

    if (transactionRecords
        .where((transactionRecord) =>
            transactionRecord.recordType == RecordType.expense)
        .isNotEmpty) {
      content = PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingExpenseSections(transactionRecords, true),
        ),
      );
    }
    return content;
  }

  Widget buildIncomeStatisticsScreen(
      List<TransactionRecord> transactionRecords) {
    Widget content = const Center(child: Text("No records yet"));
    if (transactionRecords
        .where((transactionRecord) =>
            transactionRecord.recordType == RecordType.income)
        .isNotEmpty) {
      content = PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingExpenseSections(transactionRecords, false),
        ),
      );
    }
    return content;
  }

  List<PieChartSectionData> showingExpenseSections(
      List<TransactionRecord> transactionRecords, bool isExpense) {
    return List.generate(4, (index) {
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 60.0 : 50.0;
      switch (index) {
        case 0:
          return _cusromPieChartSection(
              transactionRecords,
              isExpense ? ExpenseCategory.food : IncomeCategory.freelance,
              radius,
              isTouched,
              isExpense);
        case 1:
          return _cusromPieChartSection(
              transactionRecords,
              isExpense ? ExpenseCategory.travel : IncomeCategory.salary,
              radius,
              isTouched,
              isExpense);
        case 2:
          return _cusromPieChartSection(
              transactionRecords,
              isExpense ? ExpenseCategory.leisure : IncomeCategory.investment,
              radius,
              isTouched,
              isExpense);
        case 3:
          return _cusromPieChartSection(
              transactionRecords,
              isExpense ? ExpenseCategory.shopping : IncomeCategory.gift,
              radius,
              isTouched,
              isExpense);
        default:
          throw Error();
      }
    });
  }

  PieChartSectionData _cusromPieChartSection(
    List<TransactionRecord> transactionRecords,
    Enum category,
    double radius,
    bool showTitle,
    bool isExpense,
  ) {
    return PieChartSectionData(
      color: categoryColors[category],
      value: transactionRecords
          .where((transactionRecord) => isExpense
              ? transactionRecord.expenseCategory == category
              : transactionRecord.incomeCategory == category)
          .length
          .toDouble(),
      badgeWidget: Icon(categoryIcons[category]),
      title: category.name,
      titleStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(),
      titlePositionPercentageOffset: 1.5,
      showTitle: showTitle,
      radius: radius,
    );
  }
}
