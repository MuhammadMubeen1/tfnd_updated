import 'package:flutter/material.dart';

import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class rejectedBusinessDetails extends StatefulWidget {
  String email, imageUrl, location, phone, userName, status;
  rejectedBusinessDetails(
      {super.key,
      required this.email,
      required this.imageUrl,
      required this.location,
      required this.phone,
      required this.status,
      required this.userName});

  @override
  State<rejectedBusinessDetails> createState() =>
      _rejectedBusinessDetailsState();
}

class _rejectedBusinessDetailsState extends State<rejectedBusinessDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.hintColor,
        ),
        centerTitle: true,
        title: const ReusableText(
          title: "Business Details",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 25,
                  color: AppColor.hintColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                ReusableText(
                  title: widget.userName.toString(),
                  size: 15,
                  color: AppColor.darkTextColor,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 25,
                  color: AppColor.hintColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                ReusableText(
                  title: widget.phone.toString(),
                  size: 15,
                  color: AppColor.darkTextColor,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 25,
                  color: AppColor.hintColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                ReusableText(
                  title: widget.email.toString(),
                  size: 15,
                  color: AppColor.darkTextColor,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_city_outlined,
                  size: 25,
                  color: AppColor.hintColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ReusableText(
                    title: widget.location.toString(),
                    size: 15,
                    color: AppColor.darkTextColor,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 25,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ReusableText(
                      title: widget.status, size: 15, color: Colors.red),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
