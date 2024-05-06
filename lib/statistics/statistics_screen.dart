import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/home/cubit/home_cubit.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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
                return const Expanded(
                  child: TabBarView(
                    children: [Text("data"), Text("data")],
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
}
