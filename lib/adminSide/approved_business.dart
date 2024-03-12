import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/businessSide/beditprofile.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_outlined_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class ApprovedBusiness extends StatefulWidget {
  const ApprovedBusiness({super.key});

  @override
  State<ApprovedBusiness> createState() => _ApprovedBusinessState();
}

class _ApprovedBusinessState extends State<ApprovedBusiness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const ReusableText(
          title: "Approved Businesses",
          color: Color(0xff01B51E),
          size: 20,
          weight: FontWeight.w600,
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
            child: const ImageIcon(AssetImage("assets/icons/edit.png")),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 500,
              decoration: BoxDecoration(
                color: const Color(0xffABABAB),
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Business Name ",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Date",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Category",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemExtent: 50,
                itemBuilder: (BuildContext context, int index) {
                  return buildListItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "1.  Kfc ",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            SizedBox(),
            Text(
              "23-02-24",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Text(
              "Art",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}
