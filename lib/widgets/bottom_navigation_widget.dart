// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:money_management/Utils/constant.dart';
import 'package:money_management/pages/Home/home_page.dart';
import 'package:money_management/pages/Home/profile_page.dart';
import 'package:money_management/pages/Home/history_page.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [
    const HomePage(),
    const HistoryPage(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(50),
      //   ),
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Add_Screen()));
      //   },
      //   backgroundColor: appcolor,
      //   child: const Icon(Icons.add,color: Colors.white,),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      bottomNavigationBar:NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            index_color = index;
          });
        },
        indicatorColor: appcolor.withOpacity(0.7),
        selectedIndex: index_color,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_sharp),
            label: 'History',
          ),
          NavigationDestination(
            icon:  Icon(Icons.account_circle),
            
            label: 'Profile',
          ),
        ],
      ), 
      
      // BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   child: Padding(
      //     padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         GestureDetector(
      //           onTap: () {
      //             setState(() {
      //               index_color = 0;
      //             });
      //           },
      //           child: Icon(
      //             Icons.home,
      //             size: 35,
      //             color: index_color == 0 ?  appcolor : Colors.grey,
      //           ),
      //         ),

      //         GestureDetector(
      //           onTap: () {
      //             setState(() {
      //               index_color = 1;
      //             });
      //           },
      //           child: Icon(
      //             Icons.event_note_sharp,
      //             size: 30,
      //             color: index_color == 1 ? appcolor : Colors.grey,
      //           ),
      //         ),
      //         // const SizedBox(width: 10),
      //         // GestureDetector(
      //         //   onTap: () {
      //         //     setState(() {
      //         //       index_color = 2;
      //         //     });
      //         //   },
      //         //   child: Icon(
      //         //     Icons.account_balance_wallet_outlined,
      //         //     size: 30,
      //         //     color: index_color == 2 ? appcolor : Colors.grey,
      //         //   ),
      //         // ),
              
      //         GestureDetector(
      //           onTap: () {
      //             setState(() {
      //               index_color = 3;
      //             });
      //           },
      //           child: Icon(
      //             Icons.account_circle,
      //             size: 35,
      //             color: index_color == 3 ? appcolor : Colors.grey,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
