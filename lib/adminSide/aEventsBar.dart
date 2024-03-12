import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/adminSide/aAddEvent.dart';
import 'package:tfnd_app/screens/userSide/aEventDetail.dart';
import 'package:tfnd_app/models/AddEventModel.dart';

import 'package:tfnd_app/screens/businessSide/addEvent.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class aEventsBar extends StatefulWidget {
  const aEventsBar({super.key});

  @override
  State<aEventsBar> createState() => _aEventsBarState();
}

class _aEventsBarState extends State<aEventsBar> {
  @override
  void initState() {
    getEvents();
    // TODO: implement initState
    super.initState();
  }

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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: 55,
                  width: double.infinity,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColor.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        print('total events=${events.length}');
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const aAddEvent(),
                          ),
                        );
                      },
                      child: const Center(
                        child: ReusableText(
                          title: "Add New Event",
                          color: AppColor.pinktextColor,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: events.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                UserEmail: '',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ReusableText(
                                              title: events[index].name,
                                              color: AppColor.blackColor,
                                              weight: FontWeight.bold,
                                            ),
                                            const SizedBox(
                                              height: 1,
                                            ),
                                            ReusableText(
                                              title: events[index].Location,
                                              color: AppColor.hintColor,
                                              size: 8,
                                              weight: FontWeight.bold,
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            ReusableText(
                                              title: events[index].date,
                                              color: AppColor.textColor,
                                              size: 9.5,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Row(
                                          children: [
                                            const ReusableText(
                                              title: "\$",
                                              color: AppColor.pinktextColor,
                                              weight: FontWeight.bold,
                                              size: 18,
                                            ),
                                            ReusableText(
                                              title: events[index].price,
                                              color: AppColor.pinktextColor,
                                              weight: FontWeight.bold,
                                              size: 15,
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
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
