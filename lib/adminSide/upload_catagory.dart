import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/businessSide/beditprofile.dart';
import 'package:tfnd_app/screens/userSide/bottomnavbar.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_outlined_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class bProfileBar extends StatefulWidget {
  const bProfileBar({super.key});

  @override
  State<bProfileBar> createState() => _bProfileBarState();
}

class _bProfileBarState extends State<bProfileBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: ReusableText(
          title: "Profile",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const beditProfile(),
                  ),
                );
              },
              child: ImageIcon(AssetImage("assets/icons/edit.png"))),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/dp.jpg"),
                  radius: 70,
                ),
                const SizedBox(
                  height: 30,
                ),
                const ReusableTextForm(
                  hintText: "Alize Zain",

                  // prefixIcon: Image(image: AssetImage("assets/icons/email.png")),
                  prefixIcon: Icon(
                    Icons.person_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const ReusableTextForm(
                  hintText: "+92 337 88 33 498",
                  // prefixIcon: Image(image: AssetImage("assets/icons/email.png")),
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const ReusableTextForm(
                  hintText: "alizezain123@gmail.com",
                  // prefixIcon: Image(image: AssetImage("assets/icons/email.png")),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const ReusableTextForm(
                  hintText: "*************",

                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColor.hintColor,
                  ),
                  // prefixIcon: Image(image: AssetImage("assets/icons/email.png")),
                  prefixIcon: Icon(
                    Icons.password_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ReusableOutlinedButton(
                    title: "Switch to User Account",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => BottomNavBar(
                            userEmail: '',
                            status: '',
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                ReusableOutlinedButton(title: "Log Out", onTap: () {}),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
