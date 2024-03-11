// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_element

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_management/Utils/constant.dart';
import 'package:money_management/Utils/utils.dart';
import 'package:money_management/pages/Auth/services/auth_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uuid/uuid.dart';

late List<_ChartData> data;
late TooltipBehavior _tooltip;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserAuth auth = UserAuth();
  File? imageFile;
  TextEditingController usernamecon = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    profilepic;
    username;
    income;
    expense;
    total;
    username;
  }

  getProfilepic() async {
    var userdata = await auth.getDataFromFirestore();
    setState(() {
      profilepic = userdata!.profilepic;
      username = userdata.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    var height = screenSize.height;
    var width = screenSize.width;
    getProfilepic();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          auth.Logout();
                        },
                        icon: const Icon(
                          Icons.logout,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                          radius: width * 0.16,
                          backgroundColor: appcolor.withOpacity(0.1),
                          foregroundColor: Colors.black,
                          child: profilepic == ""
                              ? const Icon(
                                  Icons.account_circle,
                                  // size: width * 0.14,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(profilepic),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: width * 0.05,
                          backgroundColor: appcolor.withOpacity(0.8),
                          foregroundColor: Colors.white,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  getImage();
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                size: height * 0.025,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    username,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              "Edit Username",
                            ),
                            content: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              controller: usernamecon,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Not now",
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    updateUsername(usernamecon.text.trim());
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text(
                                  "Save",
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Edit Username"),
                      Icon(
                        Icons.edit_outlined,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Container(
                    width: width,
                    height: 2,
                    color: appcolor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.blueGrey, width: 0.5),
                    ),
                    child: SizedBox(
                      // height: height * .6,
                      // width: MediaQuery.of(context).size.width * .80,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total: $total",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.3,
                            endIndent: 10,
                            indent: 10,
                          ),
                          income != 0.0 || expense != 0.0
                              ? Chart(
                                  expense: expense,
                                  income: income,
                                )
                              : const EmptyChart(),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.green,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Income",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: width * 0.45,
                                    child: Text(
                                      "₹$income",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Expense",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: width * 0.45,
                                    child: Text(
                                      "₹$expense",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // _buildChart(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    await imagePicker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        setState(() {
          imageFile = File(xFile.path);
          uploadImage();
        });
      }
    });
  }

  Future updateUsername(String name) async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
      {
        'name': name,
      },
    );

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {});
  }

  Future uploadImage() async {
    String filename = const Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child('profilepic').child('$filename.jpg');
    var uploadTask = await ref.putFile(imageFile!);
    String Imageurl = await uploadTask.ref.getDownloadURL();
    await upadteprofilepic(Imageurl);
    // await refresh();
  }

  upadteprofilepic(imageurl) async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'profilepic': imageurl
    });
  }
}

class Chart extends StatefulWidget {
// ignore: prefer_const_constructors_in_immutables
  final double income, expense;
  const Chart({Key? key, required this.income, required this.expense}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  void initState() {
    data = [
      _ChartData('Icome', widget.income),
      _ChartData('Expense', widget.expense),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      tooltipBehavior: _tooltip, centerY: '50%',
      //   CircularChartAnnotation(
      //     widget: PhysicalModel(
      //       child: Container(),
      //       shape: BoxShape.circle,
      //       elevation: 10,
      //       shadowColor: Colors.black,
      //       color: const Color.fromRGBO(230, 230, 230, 1),
      //     ),
      //   ),
      //   const CircularChartAnnotation(
      //     widget: Text(
      //       '0%',
      //       style: TextStyle(
      //         color: Color.fromRGBO(0, 0, 0, 0.5),
      //         fontSize: 25,
      //       ),
      //     ),
      //   ),
      // ],

      series: <CircularSeries<_ChartData, String>>[
        DoughnutSeries<_ChartData, String>(
          emptyPointSettings: const EmptyPointSettings(color: Colors.grey, mode: EmptyPointMode.zero),
          dataSource: data,
          explodeOffset: '50%',
          innerRadius: '60%',
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
        ),
      ],
      palette: const [
        Colors.green,
        Colors.red,
      ],
      legend: const Legend(isVisible: true),
      // title: ChartTitle(
      //   text: "Total Amount \n $total",
      //   textStyle: const TextStyle(
      //     fontWeight: FontWeight.w700,
      //     overflow: TextOverflow.ellipsis,
      //   ),
      // ),
    );
  }
}

class EmptyChart extends StatefulWidget {
  const EmptyChart({super.key});

  @override
  State<EmptyChart> createState() => _EmptyChartState();
}

class _EmptyChartState extends State<EmptyChart> {
  @override
  void initState() {
    data = [
      _ChartData('Icome', 1),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      centerY: '50%',
      series: <CircularSeries<_ChartData, String>>[
        DoughnutSeries<_ChartData, String>(
          emptyPointSettings: const EmptyPointSettings(color: Colors.grey, mode: EmptyPointMode.zero),
          dataSource: data,
          explodeOffset: '50%',
          innerRadius: '60%',
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
        ),
      ],
      palette: const [
        Colors.grey,
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
