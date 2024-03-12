import 'package:flutter/material.dart';
import 'package:tfnd_app/adminSide/approvedRequests.dart';
import 'package:tfnd_app/adminSide/rejectedRequests.dart';
import 'package:tfnd_app/screens/userSide/messagesChat.dart';
import 'package:tfnd_app/screens/userSide/openChat.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class businessRequestHistory extends StatefulWidget {
  final Map<String, dynamic> approvedData;
  final Map<String, dynamic> rejectedData;
  const businessRequestHistory(
      {super.key, required this.approvedData, required this.rejectedData});

  @override
  State<businessRequestHistory> createState() => _businessRequestHistoryState();
}

class _businessRequestHistoryState extends State<businessRequestHistory> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: AppColor.hintColor,
            ),
            centerTitle: true,
            bottom: const TabBar(
              indicatorColor: AppColor.primaryColor,
              tabs: <Widget>[
                Tab(
                  text: 'Approved',
                ),
                Tab(
                  text: 'Rejected',
                ),
              ],
            ),
            title: const ReusableText(
              title: "Requests History",
              color: AppColor.pinktextColor,
              size: 20,
              weight: FontWeight.w500,
            ),
            actions: const [
              Icon(
                Icons.search_outlined,
                color: AppColor.hintColor,
                size: 28,
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: TabBarView(
            children: [
              ApprovedRequests(),
              rejectedRequests(),
            ],
          )),
    );
  }
}
