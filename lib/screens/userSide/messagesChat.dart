import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/userSide/oneToOnechat.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class messagesChat extends StatefulWidget {
  const messagesChat({super.key});

  @override
  State<messagesChat> createState() => _messagesChatState();
}

class _messagesChatState extends State<messagesChat> {
  final List<String> items = [
    "Rida Hayat",
    "Jenifer Lawerance",
    "Emma Watson",
    "Farah Khan",
    "Alize Zyan",
    "Farwa Zaid",
    "Fari Watson",
    "Alina William"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(
                height: 25,
              ),
              ListTile(
                trailing: ReusableText(
                  title: "3:44 PM",
                  color: AppColor.hintColor,
                ),
                leading: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/dp.jpg"),
                  radius: 35,
                ),
                title: ReusableText(
                  title: items[index],
                  color: AppColor.darkTextColor,
                  weight: FontWeight.w600,
                  size: 13.5,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const oneToOnechat(),
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
