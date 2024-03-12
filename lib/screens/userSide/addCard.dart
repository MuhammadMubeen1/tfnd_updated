import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tfnd_app/screens/userSide/paymentSuccessful.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class addCard extends StatefulWidget {
  const addCard({super.key});

  @override
  State<addCard> createState() => _addCardState();
}

class _addCardState extends State<addCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.hintColor),
        centerTitle: true,
        title: ReusableText(
          title: "Add Card",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage("assets/images/card3.png")),
              SizedBox(
                height: 20,
              ),
              ReusableTextForm(
                hintText: "      Card Holder Name",
              ),
              SizedBox(
                height: 20,
              ),
              ReusableTextForm(
                hintText: "      Card Number",
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ReusableTextForm(
                      hintText: "      Expiry Date",
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ReusableTextForm(
                      hintText: "      CVC",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                controlAffinity: ListTileControlAffinity.leading,
                side: BorderSide(color: AppColor.hintColor),
                title: ReusableText(
                  title: "Save Card Information",
                  weight: FontWeight.bold,
                  size: 13,
                  color: AppColor.textColor,
                ),
                activeColor: AppColor.primaryColor,
                value: timeDilation != 1.0,
                onChanged: (bool? value) {
                  setState(() {
                    timeDilation = value! ? 10.0 : 1.0;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              ReusableButton(
                  title: "Add",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const paymentSuccessful(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
