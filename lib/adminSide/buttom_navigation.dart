import 'package:flutter/material.dart';
import 'package:tfnd_app/adminSide/aEventsBar.dart';
import 'package:tfnd_app/adminSide/aUsers.dart';
import 'package:tfnd_app/adminSide/businessRequests.dart';
import 'package:tfnd_app/adminSide/storesBar.dart';

import 'package:tfnd_app/screens/businessSide/addEvent.dart';
import 'package:tfnd_app/themes/color.dart';

class Buttomnavigation extends StatefulWidget {
  Buttomnavigation({Key? key}) : super(key: key);

  @override
  State<Buttomnavigation> createState() => _ButtomnavigationState();
}

class _ButtomnavigationState extends State<Buttomnavigation> {
  int _currentIndex = 0;
  final List _pages = [
    businessRequests(),
    aEventsBar(),
    StoresBar(),
    aUsers(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          iconSize: 25,
          selectedItemColor: AppColor.primaryColor,
          unselectedItemColor: AppColor.textColor,
          onTap: (v) {
            setState(() {
              _currentIndex = v;
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                AssetImage('assets/icons/business.png'),
              ),
              label: "Business",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                AssetImage('assets/icons/event.png'),
              ),
              label: "Events",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                AssetImage('assets/icons/business.png'),
              ),
              label: "Stores",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                AssetImage('assets/icons/profile.png'),
              ),
              label: "Users",
            ),
          ],
          selectedFontSize: 16,
          unselectedFontSize: 14,
          selectedLabelStyle:
              TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
          ),
        ),
      ),
      body: _pages[_currentIndex],
    ));
  }
}
