import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/models/AddBusinessModel.dart';
import 'package:tfnd_app/screens/userSide/packages.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class businessDetails extends StatefulWidget {
  final AddBusinessModel business;
  businessDetails({super.key, required this.business});

  @override
  State<businessDetails> createState() => _businessDetailsState();
}

class _businessDetailsState extends State<businessDetails> {
  final List<String> items = [
    "Silk Abaya Collection",
    "Modern Abaya Collection",
    "Ladies Sweat Shirt Collection",
  ];

  final List<String> items1 = [
    "https://verified.imgix.net/articles/en-us/guides/fake-mac-makeup/mac-makeup.jpg?fit=max&w=1000&q=70",
    "https://renflower.lt/img/a5ee02c7308272904583cdf3c02f094f.jpg",
    "https://images.saymedia-content.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cq_auto:eco%2Cw_1200/MTczOTcyNjc5MTk0MzIyMjI3/when-does-mac-makeup-expire.png",
    "https://imageio.forbes.com/specials-images/imageserve/5f5ed273c223619de5586841/MAC-Cosmetics-cofounder-Victor-Casale-is-teaming-up-with-Joy-Chen--another-beauty/0x0.jpg?format=jpg&crop=1625,914,x0,y290,safe&width=960"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColor.hintColor, // Change this color to the desired one
          ),
          centerTitle: true,
          title: const ReusableText(
            title: "Business Details",
            color: AppColor.pinktextColor,
            size: 20,
            weight: FontWeight.w500,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 175,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          widget.business.image.toString(),
                        ),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Container(
                  child: Column(
                    children: [
                      ReusableText(
                        title: widget.business.name,
                        size: 17,
                        color: AppColor.darkTextColor,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                        title: widget.business.description,
                        size: 13,
                        color: AppColor.textColor,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          ReusableText(
                            title:
                                "Up to ${widget.business.discount ?? 'null'}% OFF",
                            color: AppColor.blackColor,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          ReusableText(
                            title: widget.business.date,
                            color: AppColor.textColor,
                            weight: FontWeight.bold,
                            size: 11,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                        title: "Collections",
                        color: AppColor.blackColor,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 230),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(items1[index]),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 100,
                            // color: Colors.green,
                            child: ReusableText(
                              title: items[index],
                              color: AppColor.darkTextColor,
                              size: 12,
                              textAlign: TextAlign.center,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
