import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/models/AddBusinessModel.dart';
import 'package:tfnd_app/screens/businessSide/addBusiness.dart';
import 'package:tfnd_app/screens/userSide/businessDetails.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class businessBar extends StatefulWidget {
  const businessBar({super.key});

  @override
  State<businessBar> createState() => _businessBarState();
}

class _businessBarState extends State<businessBar> {
  @override
  void initState() {
    getBusiness();
    // TODO: implement initState
    super.initState();
  }

  int index = 0;
  List<AddBusinessModel> businesses = [];

  getBusiness() {
    try {
      businesses.clear();
      setState(() {});
      FirebaseFirestore.instance
          .collection("BusinessRegister")
          .snapshots()
          .listen((event) {
        businesses.clear();
        setState(() {});
        for (int i = 0; i < event.docs.length; i++) {
          AddBusinessModel dataModel =
              AddBusinessModel.fromJson(event.docs[i].data());
          businesses.add(dataModel);

          print("my business == ${businesses.length}");
        }
        setState(() {});
      });
      setState(() {});
    } catch (e) {}
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: ReusableText(
          title: "Businesses at TFND",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
        actions: [
          Icon(
            Icons.search_outlined,
            color: AppColor.hintColor,
            size: 28,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            // Row(
            //   children: [
            //     ReusableText(
            //       title: "Let's Explore",
            //       color: AppColor.darkTextColor,
            //       weight: FontWeight.bold,
            //       size: 20,
            //     )
            //   ],
            // ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 30.0,
                    mainAxisExtent: 200),
                itemCount: businesses.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => businessDetails(
                            business: businesses[index],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        businesses[index].image == null ||
                                businesses[index].image!.isEmpty ||
                                businesses[index].image == ""
                            ? Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: const DecorationImage(
                                        image:
                                            AssetImage("assets/images/dp.jpg"),
                                        fit: BoxFit.cover)),
                              )
                            : Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            businesses[index].image.toString()),
                                        fit: BoxFit.cover)),
                              ),
                        const SizedBox(
                          height: 7,
                        ),
                        ReusableText(
                          title: businesses[index].name,
                          color: AppColor.darkTextColor,
                          size: 12,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        ReusableText(
                          title: businesses[index].category,
                          color: AppColor.hintColor,
                          size: 10,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ReusableText(
                              title: "Up to ",
                              color: AppColor.pinktextColor,
                              size: 12.5,
                              weight: FontWeight.bold,
                            ),
                            ReusableText(
                              title: businesses[index].discount,
                              color: AppColor.pinktextColor,
                              size: 12.5,
                              weight: FontWeight.bold,
                            ),
                            const ReusableText(
                              title: "% OFF",
                              color: AppColor.pinktextColor,
                              size: 12.5,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ]),
        ),
      ),
    );
  }
}
