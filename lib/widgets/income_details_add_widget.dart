// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/Utils/constant.dart';
import 'package:money_management/Utils/utils.dart';
import 'package:money_management/pages/Auth/services/auth_services.dart';
import 'package:money_management/widgets/custom_button_widget.dart';
import 'package:money_management/widgets/textfeild_widgets.dart';
import 'package:uuid/uuid.dart';

class IcomeAddDetailsWidget extends StatefulWidget {
  const IcomeAddDetailsWidget({super.key});
  @override
  State<IcomeAddDetailsWidget> createState() => _IcomeAddDetailsWidgetState();
}

class _IcomeAddDetailsWidgetState extends State<IcomeAddDetailsWidget> {
  DateTime date = DateTime.now();
  TextEditingController descriptionCon = TextEditingController();
  TextEditingController amountCon = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final UserAuth auth = UserAuth();
  String? selctedItem;
  var uuid = const Uuid().v1();
  late double totaleamount, totalincome;

  @override
  Widget build(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    // var height = screenSize.height;
    var width = screenSize.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: IcomeDetailsAddWidget(width),
    );
  }

  Padding IcomeDetailsAddWidget(double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            const Spacer(),
            name(),
            const Spacer(),
            description(),
            const Spacer(),
            amount(),
            const Spacer(),
            date_time(),
            const Spacer(),
            saveData(width),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget date_time() {
    return GestureDetector(
      onTap: () async {
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (newDate == Null) return;
        setState(() {
          date = newDate!;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: const Color(
              0xffC5C5C5,
            ),
          ),
        ),
        child: Text(
          'Date : ${date.year} / ${date.day} / ${date.month}',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget saveData(width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: CustomMainButton(
        color: appcolor,
        isLoading: isLoading,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          if (_formkey.currentState!.validate()) {
            String formateddate = DateFormat('dd/MM/yyy').format(date);
            String monthyear = DateFormat('MMM y').format(date);
            GetUserData();
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('userdata').doc(uuid).set({
              'type': 'income',
              'selected type': selctedItem,
              'description': descriptionCon.text.toString(),
              'amount': double.parse(amountCon.text),
              'addtime': date,
              'date': formateddate,
              'monthyear': monthyear,
              'id': uuid,
            });

            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
              {
                'totaleamount': totaleamount + double.parse(amountCon.text),
                'totalincome': totalincome + double.parse(amountCon.text),
              },
            );

            print("Successfully Add");
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: Text(
          "Save",
          style: TextStyle(color: Colors.white, fontSize: width * 0.05),
        ),
      ),
    );
  }

  Widget amount() {
    return TextFieldWidget(
      textCapitalization: TextCapitalization.none,
      controller: amountCon,
      obscureText: false,
      hintText: "Enter Amount",
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "please enter Amount";
        } else if (value.contains(RegExp(r'[A-Za-z]'))) {
          return "please enter amount in numbers";
        }
        return null;
      },
    );
  }

  Widget description() {
    return TextFieldWidget(
      textCapitalization: TextCapitalization.words,
      controller: descriptionCon,
      obscureText: false,
      hintText: "Enter Description (Optional)",
      keyboardType: TextInputType.name,
    );
  }

  Widget name() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: const Color(0xffC5C5C5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          validator: (val) {
            if (val == null) {
              return 'Please select an option';
            }
            return null;
          },
          value: selctedItem,
          onChanged: ((value) {
            setState(() {
              selctedItem = value!;
            });
          }),
          items: incomeitems
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          e,
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          selectedItemBuilder: (BuildContext context) => incomeitems
              .map((e) => Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(e)
                    ],
                  ))
              .toList(),
          hint: const Text(
            'Select Type',
            style: TextStyle(color: Colors.grey),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          // underline: Container(),
        ),
      ),
    );
  }

  Column background_container(BuildContext context) {
    Size screenSize = Utils().getScreenSize(context);
    var height = screenSize.height;
    // var width = screenSize.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height * 0.3,
          decoration: const BoxDecoration(
            color: Color(0xff368983),
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

  GetUserData() async {
    var userdata = await auth.getDataFromFirestore();
    setState(() {
      totalincome = userdata!.totalincome;
      totaleamount = userdata.totaleamount;
    });
  }
}
