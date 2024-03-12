import 'package:flutter/material.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class oneToOnechat extends StatefulWidget {
  const oneToOnechat({super.key});

  @override
  State<oneToOnechat> createState() => _oneToOnechatState();
}

class _oneToOnechatState extends State<oneToOnechat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColor.hintColor),
            title: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/images/dp.jpg"),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      title: "Rida Hayat",
                      color: AppColor.darkTextColor,
                      weight: FontWeight.w600,
                      size: 15,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ReusableText(
                      title: "3:44 PM",
                      color: AppColor.textColor,
                      size: 11,
                    ),
                  ],
                ))),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(child: Container()),
                Container(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: ReusableTextForm(
                          hintText: "      Type Message",
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.send,
                        color: AppColor.primaryColor,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
