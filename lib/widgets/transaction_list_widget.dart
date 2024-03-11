import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_management/Utils/utils.dart';

class TransactionListWidget extends StatefulWidget {
  const TransactionListWidget({super.key, required this.monthyear, required this.type});
  final String monthyear, type;
  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  List monthHistory = [];

  gethistory() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userdata")
        .orderBy("addtime", descending: false)
        .where(
          'monthyear',
          isEqualTo: widget.monthyear,
        )
        .where(
          'type',
          isEqualTo: widget.type,
        )
        .get()
        .then((value) {
      if (mounted) {
        setState(
          () {
            monthHistory = value.docs;
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    gethistory();
  }

  @override
  Widget build(BuildContext context) {
    gethistory();
    Size screenSize = Utils().getScreenSize(context);
    var height = screenSize.height;
    var width = screenSize.width;

    return SingleChildScrollView(
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: monthHistory.length,
        itemBuilder: (context, index) {
          var data = monthHistory[index];
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
    );

//its for limited data get.
    // Query query = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection("userdata")
    //     .orderBy("addtime", descending: false)
    //     .where(
    //       'monthyear',
    //       isEqualTo: widget.monthyear,
    //     )
    //     .where(
    //       'type',
    //       isEqualTo: widget.type,
    //     );
    // return FutureBuilder(
    //     future: query.limit(150).get(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.hasError) {
    //         return const Center(child: Text("Something went wrong"));
    //       } else if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(child: Text("Loading..."));
    //       } else if (!snapshot.hasData == snapshot.data!.docs.isEmpty) {
    //         return const Center(child: Text("No Transaction found."));
    //       } else {
    //         var datas = snapshot.data!.docs;
    //         return ListView.builder(
    //           // reverse: true,
    //           shrinkWrap: true,
    //           physics: const NeverScrollableScrollPhysics(),
    //           itemCount: datas.length,
    //           itemBuilder: (context, index) {
    //             var data = datas[index];
    //             var type = data['type'];
    //             String des = data['description'];
    //             var docid = data['id'];
    //             var amount = data['amount'];
    //             return Slidable(
    //               enabled: true,
    //               key: const ValueKey(0),
    //               endActionPane: ActionPane(
    //                 motion: const ScrollMotion(),
    //                 // dismissible: DismissiblePane(onDismissed: () {}),
    //                 children: [
    //                   SlidableAction(
    //                     onPressed: (context) {
    //                       doing(context, docid, amount, type);
    //                     },
    //                     backgroundColor: const Color(0xFFFE4A49),
    //                     foregroundColor: Colors.white,
    //                     icon: Icons.delete,
    //                     label: 'Delete',
    //                   ),
    //                 ],
    //               ),
    //               child: listview(
    //                 type,
    //                 data,
    //                 width,
    //                 des,
    //               ),
    //             );
    //           },
    //         );
    //       }
    //     });
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
}
