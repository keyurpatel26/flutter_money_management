// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:money_management/Utils/constant.dart';
import 'package:money_management/Utils/utils.dart';
import 'package:money_management/widgets/expense_detail_add_widget.dart';
import 'package:money_management/widgets/income_details_add_widget.dart';

class Add_Screen extends StatefulWidget {
  const Add_Screen({super.key});

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> with SingleTickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    var height = screenSize.height;
    var width = screenSize.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            background_container(context),
            Positioned(
              top: height*0.2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                height: height * 0.6,
                width: width * 0.8,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: TabBar(
                        unselectedLabelColor: Colors.grey,
                        labelColor: appcolor,
                        dividerColor: Colors.transparent,
                        // indicatorWeight: 5,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        controller: tabController,
                        indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: -20,
                        ),
                        tabs: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Tab(
                              height: height * 0.04,
                              // child: ,
                              text: '    Income    ',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Tab(
                              height: height * 0.04,
                              text: 'Expense',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: const [
                          IcomeAddDetailsWidget(),
                          ExpensesAddDetailsWidget(),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          //   child: Column(
                          //     children: [
                          //       const Spacer(),
                          //       name(),
                          //       const Spacer(),
                          //       explain(),
                          //       const Spacer(),
                          //       amount(),
                          //       const Spacer(),
                          //       date_time(),
                          //       const Spacer(),
                          //       save(),
                          //       const Spacer(),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
   
  Column background_container(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    var height = screenSize.height;
    var width = screenSize.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height * 0.3,
          decoration: const BoxDecoration(
            color: appcolor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Text(
                      'Adding',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    const Icon(
                      Icons.attach_file_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
