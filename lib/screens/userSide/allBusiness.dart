// import 'package:flutter/material.dart';
// import 'package:tfnd_app/screens/userSide/businessDetails.dart';
// import 'package:tfnd_app/themes/color.dart';
// import 'package:tfnd_app/widgets/reusable_text.dart';

// class allBusiness extends StatefulWidget {
//   const allBusiness({super.key});

//   @override
//   State<allBusiness> createState() => _allBusinessState();
// }

// class _allBusinessState extends State<allBusiness> {
//   final List<String> data = [
//     "Alteri Athletics",
//     "Hijabi Culture",
//     "J.Jeans",
//     "Bonanza",
//     "Satrangi"
//   ];
//   final List<String> data1 = [
//     "Casual Deal",
//     "Summer Deal",
//     "Winter Deal",
//     "Fresh Arrival",
//     "New Year Eve"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Column(
//         children: [
//           Row(
//             children: [
//               ReusableText(
//                 title: "Featured Business",
//                 color: AppColor.textColor,
//                 weight: FontWeight.bold,
//                 size: 14,
//               )
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute<void>(
//                   builder: (BuildContext context) => const businessDetails(),
//                 ),
//               );
//             },
//             child: Container(
//               // color: Colors.green,
//               height: 210,
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: data.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 1, childAspectRatio: 1.45),
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     children: [
//                       Container(
//                         height: 130,
//                         width: 130,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             image: DecorationImage(
//                                 image: AssetImage(
//                                     "assets/images/cardbusiness1.png"))),
//                       ),
//                       SizedBox(
//                         height: 7,
//                       ),
//                       ReusableText(
//                         title: data[index],
//                         color: AppColor.darkTextColor,
//                         size: 12,
//                         weight: FontWeight.bold,
//                       ),
//                       SizedBox(
//                         height: 2,
//                       ),
//                       ReusableText(
//                         title: data1[index],
//                         color: AppColor.hintColor,
//                         size: 10,
//                         weight: FontWeight.bold,
//                       ),
//                       SizedBox(
//                         height: 4,
//                       ),
//                       ReusableText(
//                         title: "Up to 50% OFF",
//                         color: AppColor.pinktextColor,
//                         size: 12.5,
//                         weight: FontWeight.bold,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Row(
//             children: [
//               ReusableText(
//                 title: "Explore Business",
//                 color: AppColor.textColor,
//                 weight: FontWeight.bold,
//                 size: 14,
//               )
//             ],
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Container(
//             // color: Colors.green,
//             height: 210,
//             child: GridView.builder(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemCount: data.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 1, childAspectRatio: 1.45),
//               itemBuilder: (BuildContext context, int index) {
//                 return Column(
//                   children: [
//                     Container(
//                       height: 130,
//                       width: 130,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           image: DecorationImage(
//                               image: AssetImage(
//                                   "assets/images/cardbusiness2.webp"))),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     ReusableText(
//                       title: data[index],
//                       color: AppColor.darkTextColor,
//                       size: 12,
//                       weight: FontWeight.bold,
//                     ),
//                     SizedBox(
//                       height: 2,
//                     ),
//                     ReusableText(
//                       title: data1[index],
//                       color: AppColor.hintColor,
//                       size: 10,
//                       weight: FontWeight.bold,
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     ReusableText(
//                       title: "Up to 50% OFF",
//                       color: AppColor.pinktextColor,
//                       size: 12.5,
//                       weight: FontWeight.bold,
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/models/AddBusinessModel.dart';
import 'package:tfnd_app/screens/businessSide/addBusiness.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class bBusinessBar extends StatefulWidget {
  const bBusinessBar({super.key});

  @override
  State<bBusinessBar> createState() => _bBusinessBarState();
}

class _bBusinessBarState extends State<bBusinessBar> {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
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
                  return Column(
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
                                      image: AssetImage("assets/images/dp.jpg"),
                                      fit: BoxFit.contain)),
                            )
                          : Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          businesses[index].image.toString()),
                                      fit: BoxFit.contain)),
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
                      ReusableText(
                        title: "Up to ${businesses[index].discount} OFF",
                        color: AppColor.pinktextColor,
                        size: 12.5,
                        weight: FontWeight.bold,
                      ),
                    ],
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
