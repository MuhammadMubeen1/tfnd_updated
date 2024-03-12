import 'package:flutter/material.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import '../themes/color.dart';

class ReusableOutlinedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final Color buttonColor;
  const ReusableOutlinedButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.buttonColor = AppColor.transparentColor,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 43,
        width: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(30),
            color: buttonColor),
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColor.pinktextColor,
              )
            : ReusableText(
                title: title,
                size: 11,
                weight: FontWeight.bold,
                color: AppColor.pinktextColor,
              ),
      ),
    );
  }
}
