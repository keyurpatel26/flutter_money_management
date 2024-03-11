import 'package:flutter/material.dart';
import 'package:money_management/widgets/transaction_list_widget.dart';

class TypeTabbar extends StatelessWidget {
  const TypeTabbar({super.key, required this.monthyear});
  final String monthyear;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(
                    text: "Credit",
                  ),
                  Tab(
                    text: "Debit",
                  ),
                ],
              ),
              Expanded(
                  child: TabBarView(children: [
                TransactionListWidget(
                  monthyear: monthyear,
                  type: 'income',
                ),
                TransactionListWidget(
                  monthyear: monthyear,
                  type: 'expense',
                ),
              ]))
            ],
          )),
    );
  }
}
