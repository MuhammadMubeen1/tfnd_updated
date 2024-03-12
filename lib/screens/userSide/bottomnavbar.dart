import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tfnd_app/models/AddUserModel.dart';
import 'package:tfnd_app/screens/userSide/businessBar.dart';
import 'package:tfnd_app/screens/userSide/chatBar.dart';
import 'package:tfnd_app/screens/userSide/eventsBar.dart';
import 'package:tfnd_app/screens/userSide/homeBar.dart';
import 'package:tfnd_app/screens/userSide/profileBar.dart';
import 'package:tfnd_app/screens/userSide/scanner.dart';
import 'package:tfnd_app/themes/color.dart';

class BottomNavBar extends StatefulWidget {
  String userEmail, status;

  BottomNavBar({Key? key, required this.userEmail, required this.status})
      : super(key: key);
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  List<Widget>? _pages;
  String? isPaid;

  // Initialize Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //late Future<AddUserModel?> _userDataFuture;

  // Future<AddUserModel?> getUserData(String currentUserEmail) async {
  //   try {
  //     QuerySnapshot userSnapshot = await FirebaseFirestore.instance
  //         .collection('RegisterUsers')
  //         .where('email', isEqualTo: currentUserEmail)
  //         .get();

  //     if (userSnapshot.docs.isNotEmpty) {
  //       final userData = AddUserModel.fromJson(
  //           userSnapshot.docs.first.data() as Map<String, dynamic>);

  //       if (userData.subscription!.isNotEmpty) {
  //         isPaid = userData.subscription;
  //         setState(() {
  //           isPaid;
  //         });
  //         print("if working status is ${isPaid}");
  //       } else {
  //         print("else working ${isPaid}");
  //       }

  //       return userData; // Return the fetched user data
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error fetching user data: $e");
  //     return null;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _pages = [
      homeBar(curentuser: widget.userEmail),
      businessBar(),
      Scanner(widget.userEmail),
      eventsBar(
        useremail: widget.userEmail,
      ),
      profileBar(
        currentUserEmail: widget.userEmail,
      ),
    ];

    // _userDataFuture.then((userData) {
    //   if (userData != null && userData.subscription != null) {
    //     setState(() {
    //       isPaid = userData.subscription;
    //     });
    //     print("if working status is ${isPaid}");
    //   } else {
    //     print("else working ${isPaid}");
    //   }

    //   _currentIndex = _currentIndex.clamp(0, _pages!.length - 1);

    //   setState(() {});
    // });

    print("current email == = ${widget.userEmail}");
    print(widget.status);
  }

  @override
  void dispose() {
    isPaid;
    // TODO: implement dispose

    super.dispose();
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
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: ImageIcon(
                  AssetImage('assets/icons/home.png'),
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: ImageIcon(
                  AssetImage('assets/icons/business.png'),
                ),
                label: "Business",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.document_scanner_outlined),
                label: "Discounts",
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
                  AssetImage('assets/icons/profile.png'),
                ),
                label: "Profile",
              ),
            ],
            selectedFontSize: 16,
            unselectedFontSize: 14,
            selectedLabelStyle:
                const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
        body: _pages?[_currentIndex],
      ),
    );
  }
}
