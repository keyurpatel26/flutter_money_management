// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_management/Utils/constant.dart';
import 'package:money_management/Utils/utils.dart';
import 'package:money_management/pages/Auth/services/auth_services.dart';
import 'package:money_management/pages/Home/add_chart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserAuth auth = UserAuth();
  Map<String, dynamic> delethistory = {};
  String type = "";

  @override
  void initState() {
    super.initState();
    getProfilepic();
  }

  getUserdata() async {
    var userdata = await auth.getDataFromFirestore();
    if (mounted) {
      setState(() {
        username = userdata!.name;
        income = userdata.totalincome;
        expense = userdata.totalexpense;
        total = userdata.totaleamount;
      });
    }
  }

  getProfilepic() async {
    var userdata = await auth.getDataFromFirestore();
    if (mounted) {
      setState(() {
        profilepic = userdata!.profilepic;
      });
    }
  }

  gethistory() async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("userdata").orderBy("addtime", descending: false).get().then(
      (value) {
        if (mounted) {
          setState(
            () {
              history = value.docs;
            },
          );
        }
      },
    );
  }

  Future deleteData(String id, double amount, String type) async {
    try {
      if (type == "income") {
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          'totaleamount': total - amount,
          'totalincome': income - amount,
        });
      } else {
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          'totaleamount': total + amount,
          'totalexpense': expense - amount,
        });
      }
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("userdata").doc(id).delete();
    } catch (e) {
      return false;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    getUserdata();
    gethistory();
    Size screenSize = Utils().getScreenSize(context);
    var height = screenSize.height;
    var width = screenSize.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Add_Screen(),
            ),
          );
        },
        backgroundColor: appcolor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height * 0.42,
                ),
                ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    var data = history[index];
                    var type = data['type'];
                    String des = data['description'];
                    var docid = data['id'];
                    var amount = data['amount'];
                    return Slidable(
                      enabled: true,
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        // dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              doing(context, docid, amount, type);
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: listview(
                        type,
                        data,
                        width,
                        des,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              top_card(
                width: width,
                username: username,
                height: height,
                income: income,
                expense: expense,
                total: total,
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                      child: Text(
                        "Recent transactions",
                        style: TextStyle(fontSize: height * 0.03),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Padding listview(type, data, double width, String des) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: type == "income" ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              type == "income" ? Icons.arrow_upward : Icons.arrow_downward,
              color: type == "income" ? Colors.green : Colors.red,
            ),
          ),
          title: Text(
            data['selected type'].toString(),
            style: TextStyle(
              fontSize: width * 0.05,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              des.isEmpty
                  ? const SizedBox()
                  : Text(
                      data['description'].toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
              Text(data['date'].toString()),
            ],
          ),
          trailing: Container(
            alignment: Alignment.centerRight,
            width: width * 0.28,
            child: Text(
              "₹${data['amount']}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: width * 0.04,
                color: type == "income" ? Colors.green : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  doing(BuildContext context, String id, double amount, String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                deleteData(id, amount, type);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class top_card extends StatelessWidget {
  const top_card({
    super.key,
    required this.width,
    required this.username,
    required this.height,
    required this.income,
    required this.expense,
    required this.total,
  });

  final double width;
  final String username;
  final double height;
  final double income;
  final double expense;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      // height: height * 0.4,
      decoration: const BoxDecoration(
        color: appcolor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello,",
                style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                username,
                style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Total Balance",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: height * 0.02,
                ),
              ),
              Text(
                "₹$total",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: height * 0.06,
                ),
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    // height: height * 0.1,
                    // width: width * 0.4,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Credit",
                          style: TextStyle(color: Colors.green, fontSize: height * 0.02),
                        ),
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              width: width * 0.5,
                              child: Text(
                                "₹ $income",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: appcolor.withOpacity(0.8), fontSize: height * 0.04),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_upward,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    // height: height * 0.1,
                    // width: width * 0.4,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Debit",
                          style: TextStyle(color: Colors.red, fontSize: height * 0.02),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                width: width * 0.5,
                                child: Text(
                                  "₹ $expense",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: appcolor.withOpacity(0.8), fontSize: height * 0.04),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
