import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/businessSide/bBusinessBar.dart';
import 'package:tfnd_app/screens/businessSide/bProfileBar.dart';
import 'package:tfnd_app/screens/businessSide/qr_code.dart';
import 'package:tfnd_app/themes/color.dart';

class bBottomnavbar extends StatefulWidget {
  String? currentuser;
  bBottomnavbar({Key? key, required this.currentuser})
      : super(
          key: key,
        );

  @override
  State<bBottomnavbar> createState() => _bBottomnavbarState();
}

class _bBottomnavbarState extends State<bBottomnavbar> {
  int _currentIndex = 0;
  late List _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      bBusinessBar(
        emailuser: widget.currentuser.toString(),
      ),
      QRCodeScreen(),
      bProfileBar(currentuser: widget.currentuser.toString())
    ];
  }

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
                label: "QR Code",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: ImageIcon(
                  AssetImage('assets/icons/profile.png'),
                ),
                label: "Profile",
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
      ),
    );
  }
}
