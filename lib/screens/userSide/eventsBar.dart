import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/models/AddUserModel.dart';
import 'package:tfnd_app/screens/userSide/aEventDetail.dart';
import 'package:tfnd_app/models/AddEventModel.dart';
import 'package:tfnd_app/screens/userSide/allEvents.dart';
import 'package:tfnd_app/screens/userSide/nearyouEvents.dart';
import 'package:tfnd_app/screens/userSide/popularEvents.dart';
import 'package:tfnd_app/screens/userSide/upcomingEvents.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class eventsBar extends StatefulWidget {
  final String? useremail;
  eventsBar({super.key, required this.useremail});

  @override
  State<eventsBar> createState() => _eventsBarState();
}

class _eventsBarState extends State<eventsBar> {
  int index = 0;

  void initState() {
    getEvents();
    // TODO: implement initState
    super.initState();
  }

  late Future<AddUserModel?> userDataFuture;

  List<AddEventModel> events = [];

  getEvents() {
    try {
      events.clear();
      setState(() {});
      FirebaseFirestore.instance
          .collection("adminevents")
          .snapshots()
          .listen((event) {
        events.clear();
        setState(() {});
        for (int i = 0; i < event.docs.length; i++) {
          AddEventModel dataModel =
              AddEventModel.fromJson(event.docs[i].data());
          events.add(dataModel);

          print("my event == ${events.length}");
        }
        setState(() {});
      });
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const ReusableText(
            title: "Events",
            color: AppColor.pinktextColor,
            size: 20,
            weight: FontWeight.w500,
          ),
          actions: const [
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: events.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  // childAspectRatio: 0.2,
                  mainAxisExtent: 250,
                  mainAxisSpacing: 0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => eventsDetail(
                          event: events[index],
                          UserEmail: widget.useremail.toString(),
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      events[index].image == null
                          ? Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: NetworkImage(
                                          "https://d2x3xhvgiqkx42.cloudfront.net/12345678-1234-1234-1234-1234567890ab/651c25b0-2d60-43c8-addf-1df2fd575568/2021/08/16/455d8bde-5940-4005-a79a-56005926c158/65b4998a-5202-4a77-af1e-c646f5fc36e1.png"),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          events[index].image.toString()),
                                      fit: BoxFit.cover)),
                            ),
                      Positioned(
                          top: 140,
                          left: 20,
                          right: 20,
                          child: Container(
                            height: 70,
                            width: 310,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ReusableText(
                                        title: events[index].name,
                                        color: AppColor.blackColor,
                                        weight: FontWeight.bold,
                                        size: 13,
                                      ),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      ReusableText(
                                        title: events[index].Location,
                                        color: AppColor.hintColor,
                                        size: 9,
                                        weight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      ReusableText(
                                        title: events[index].date,
                                        color: AppColor.textColor,
                                        size: 11.5,
                                        weight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Row(
                                    children: [
                                      const ReusableText(
                                        title: "\$",
                                        color: AppColor.pinktextColor,
                                        weight: FontWeight.bold,
                                        size: 16,
                                      ),
                                      ReusableText(
                                        title: events[index].price,
                                        color: AppColor.pinktextColor,
                                        weight: FontWeight.bold,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                );
              },
            ),
            // ListView.builder(
            //   itemCount: events.length,
            //   itemBuilder: (context, index) {
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 20),
            //       child: GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute<void>(
            //               builder: (BuildContext context) => eventsDetail(
            //                   event: events[index],
            //                   UserEmail: widget.useremail.toString()),
            //             ),
            //           );
            //         },
            //         child: Stack(
            //           children: [
            //             events[index].image == null
            //                 ? Container(
            //                     height: 210,
            //                     width: double.infinity,
            //                     decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(15),
            //                         image: const DecorationImage(
            //                             image: NetworkImage(
            //                                 "https://d2x3xhvgiqkx42.cloudfront.net/12345678-1234-1234-1234-1234567890ab/651c25b0-2d60-43c8-addf-1df2fd575568/2021/08/16/455d8bde-5940-4005-a79a-56005926c158/65b4998a-5202-4a77-af1e-c646f5fc36e1.png"),
            //                             fit: BoxFit.contain)),
            //                   )
            //                 : Container(
            //                     height: 230,
            //                     width: double.infinity,
            //                     decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(30),
            //                         image: DecorationImage(
            //                             image: NetworkImage(
            //                                 events[index].image.toString()),
            //                             fit: BoxFit.fill)),
            //                   ),
            //             Positioned(
            //                 top: 140,
            //                 left: 20,
            //                 right: 20,
            //                 child: Container(
            //                   height: 90,
            //                   width: 340,
            //                   decoration: BoxDecoration(
            //                       color: AppColor.backgroundColor,
            //                       borderRadius: BorderRadius.circular(15)),
            //                   child: Row(
            //                     children: [
            //                       const SizedBox(
            //                         width: 20,
            //                       ),
            //                       Column(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: [
            //                           ReusableText(
            //                             title: events[index].date,
            //                             color: AppColor.primaryColor,
            //                             size: 9,
            //                             weight: FontWeight.bold,
            //                           ),
            //                           const SizedBox(
            //                             height: 5,
            //                           ),

            //                           Center(
            //                               child:
            //                                   Text("\$${events[index].price}")),
            //                           // ReusableText(
            //                           //   title: events[index].price,
            //                           //   color: AppColor.primaryColor,
            //                           //   size: 18,
            //                           //   weight: FontWeight.bold,
            //                           // )
            //                         ],
            //                       ),
            //                       const SizedBox(
            //                         width: 20,
            //                       ),
            //                       Column(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           ReusableText(
            //                             title: events[index].name,
            //                             color: AppColor.blackColor,
            //                             weight: FontWeight.bold,
            //                             size: 10,
            //                           ),
            //                           const SizedBox(
            //                             height: 5,
            //                           ),
            //                           Container(
            //                             width: 100,
            //                             child: ReusableText(
            //                               title: events[index].Location,
            //                               color: AppColor.hintColor,
            //                               size: 9,
            //                               weight: FontWeight.bold,
            //                             ),
            //                           )
            //                         ],
            //                       )
            //                     ],
            //                   ),
            //                 ))
            //           ],
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ),
        ));
  }
}
