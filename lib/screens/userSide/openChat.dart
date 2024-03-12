import 'package:flutter/material.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class openChat extends StatefulWidget {
  const openChat({super.key});

  @override
  State<openChat> createState() => _openChatState();
}

class _openChatState extends State<openChat> {
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
                onTap: () {},
              )
            ],
          );
        },
      ),
    );
  }
}
