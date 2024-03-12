import 'package:flutter/material.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import '../themes/color.dart';

class ReusableButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLoading;
  final Color buttonColor;
  const ReusableButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.buttonColor = AppColor.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: buttonColor),
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColor.whiteColor,
              )
            : ReusableText(
                title: title,
                size: 16,
                weight: FontWeight.w900,
                color: AppColor.whiteColor,
              ),
      ),
    );
  }
}
