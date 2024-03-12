import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/userSide/paymentMethod.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class packages extends StatefulWidget {
  const packages({super.key});

  @override
  State<packages> createState() => _packagesState();
}

class _packagesState extends State<packages> {
  int? _value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.hintColor),
        centerTitle: true,
        title: ReusableText(
          title: "Packages",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: AppColor.hintColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                title: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: Image(
                        image: AssetImage('assets/images/card1.png'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        ReusableText(
                          title: "Silver",
                          color: AppColor.darkTextColor,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 93,
                        ),
                        ReusableText(
                          title: "\$20",
                          color: AppColor.darkTextColor,
                          weight: FontWeight.bold,
                          size: 20,
                        ),
                      ],
                    )
                  ],
                ),
                value: 1,
                groupValue: _value,
                onChanged: (val) {
                  setState(() {
                    _value = val;
                  });
                },
                activeColor: AppColor.primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: AppColor.hintColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                title: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: Image(
                        image: AssetImage('assets/images/card2.png'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        ReusableText(
                          title: "Gold",
                          color: AppColor.goldColor,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        ReusableText(
                          title: "\$30",
                          color: AppColor.goldColor,
                          weight: FontWeight.bold,
                          size: 20,
                        ),
                      ],
                    )
                  ],
                ),
                value: 2,
                groupValue: _value,
                onChanged: (val) {
                  setState(() {
                    _value = val;
                  });
                },
                activeColor: AppColor.primaryColor,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: AppColor.hintColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: RadioListTile(
                title: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      child: Image(
                        image: AssetImage('assets/images/card1.png'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        ReusableText(
                          title: "Platinum",
                          color: AppColor.blackColor,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 62,
                        ),
                        ReusableText(
                          title: "\$50",
                          color: AppColor.blackColor,
                          weight: FontWeight.bold,
                          size: 20,
                        ),
                      ],
                    )
                  ],
                ),
                value: 3,
                groupValue: _value,
                onChanged: (val) {
                  setState(() {
                    _value = val;
                  });
                },
                controlAffinity: ListTileControlAffinity.trailing,
                activeColor: AppColor.primaryColor,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ReusableButton(
                title: "Subscribe",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => paymentMethod(),
                    ),
                  );
                })
          ],
        ),
      )),
    );
  }
}
