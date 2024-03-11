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
    );
  }
}
