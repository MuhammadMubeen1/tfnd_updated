import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/userSide/bottomnavbar.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class paymentSuccessful extends StatefulWidget {
  const paymentSuccessful({super.key});

  @override
  State<paymentSuccessful> createState() => _paymentSuccessfulState();
}

class _paymentSuccessfulState extends State<paymentSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 100,
                    width: 100,
                    child:
                        Image(image: AssetImage("assets/icons/success.png"))),
                SizedBox(
                  height: 40,
                ),
                ReusableText(
                  title: "Subscribed Successfully",
                  color: AppColor.blackColor,
                  weight: FontWeight.bold,
                  size: 20,
                ),
                SizedBox(
                  height: 15,
                ),
                ReusableText(
                  title: "You have successfully subscribed our",
                  color: AppColor.textColor,
                ),
                SizedBox(
                  height: 20,
                ),
                ReusableText(
                  title: "Gold package",
                  color: AppColor.goldColor,
                  weight: FontWeight.bold,
                  size: 22,
                ),
              ],
            ),
            ReusableButton(
                title: "Go to home",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavBar(
                              status: '',
                              userEmail: '',
                            )),
                  );
                })
          ],
        ),
      ),
    );
  }
}
