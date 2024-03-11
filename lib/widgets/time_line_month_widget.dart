import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/Utils/constant.dart';
import 'package:money_management/Utils/utils.dart';

class TimeLineMonth extends StatefulWidget {
  const TimeLineMonth({super.key, required this.onChange});
  final ValueChanged<String?> onChange;

  @override
  State<TimeLineMonth> createState() => _TimeLineMonthState();
}

class _TimeLineMonthState extends State<TimeLineMonth> {
  String currentMonth = "";
  List<String> months = [];
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    for (int i = -12; i <= 0; i++) {
      months.add(
        DateFormat('MMM y').format(
          DateTime(now.year, now.month + i, 1),
        ),
      );
    }
    currentMonth = DateFormat('MMM y').format(now);
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollToSelectMonth();
    });
  }

  scrollToSelectMonth() {
    final selectedMonthIndex = months.indexOf(currentMonth);
    if (selectedMonthIndex != -1) {
      final scrollOfSet = (selectedMonthIndex * 100.0) - 170;
      scrollController.animateTo(
        scrollOfSet,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    var height = screenSize.height;
    var width = screenSize.width;
    return Container(
      height: height * 0.06,
      child: ListView.builder(
        controller: scrollController,
        itemCount: months.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                currentMonth = months[index];
                widget.onChange(months[index]);
              });
              scrollToSelectMonth();
            },
            child: Container(
              // padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              width: width * 0.2,
              decoration: BoxDecoration(
                border: Border.all(color: appcolor),
                color: currentMonth == months[index] ? appcolor : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  months[index],
                  style: TextStyle(color: currentMonth == months[index] ? Colors.white : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
