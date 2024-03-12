import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/userSide/addCard.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class paymentMethod extends StatefulWidget {
  const paymentMethod({super.key});

  @override
  State<paymentMethod> createState() => _paymentMethodState();
}

class _paymentMethodState extends State<paymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.hintColor),
        centerTitle: true,
        title: ReusableText(
          title: "Payment Method",
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
              SizedBox(height: 30),
              Row(
                children: [
                  ReusableText(
                    title: "Credit & Debit Card",
                    size: 16,
                    weight: FontWeight.bold,
                    color: AppColor.darkTextColor,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => addCard(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.credit_card,
                    size: 30,
                    color: AppColor.primaryColor,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ReusableText(
                      title: "Credit Card",
                      color: AppColor.textColor,
                      weight: FontWeight.bold,
                    ),
                  )),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}
