import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/widgets/time_line_month_widget.dart';
import 'package:money_management/widgets/type_tab_bar_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var monthyear = "";
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      monthyear = DateFormat('MMM y').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Transaction",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
            TimeLineMonth(
              onChange: (String? value) {
                if (value != null) {
                  setState(() {
                    monthyear = value;
                  });
                }
              },
            ),
            TypeTabbar(
              monthyear: monthyear,
            ),
          ],
        ),
      ),
    );
  }
}
