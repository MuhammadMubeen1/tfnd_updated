import 'package:flutter/material.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class approvedBusinessDetails extends StatefulWidget {
  String email, imageUrl, location, phone, userName, status;

  approvedBusinessDetails(
      {super.key,
      required this.email,
      required this.imageUrl,
      required this.location,
      required this.phone,
      required this.userName,
      required this.status});

  @override
  State<approvedBusinessDetails> createState() =>
      _approvedBusinessDetailsState();
}

class _approvedBusinessDetailsState extends State<approvedBusinessDetails> {
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
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                  title: widget.userName,
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
            Divider(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 25,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ReusableText(
                      title: widget.status, size: 15, color: Colors.green),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
