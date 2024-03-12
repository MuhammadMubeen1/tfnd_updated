import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/userSide/messagesChat.dart';
import 'package:tfnd_app/screens/userSide/openChat.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class chatBar extends StatefulWidget {
  const chatBar({super.key});

  @override
  State<chatBar> createState() => _chatBarState();
}

class _chatBarState extends State<chatBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColor.primaryColor,
            tabs: <Widget>[
              Tab(
                text: 'Messages',
              ),
              Tab(
                text: 'Open',
              ),
            ],
          ),
          title: ReusableText(
            title: "Chat",
            color: AppColor.pinktextColor,
            size: 20,
            weight: FontWeight.w500,
          ),
          actions: [
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
          children: [messagesChat(), openChat()],
        ),
      ),
    );
  }
}
