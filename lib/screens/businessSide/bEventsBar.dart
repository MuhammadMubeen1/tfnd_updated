import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/models/AddEventModel.dart';
import 'package:tfnd_app/screens/businessSide/addEvent.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class bEventsBar extends StatefulWidget {
  const bEventsBar({super.key});

  @override
  State<bEventsBar> createState() => _bEventsBarState();
}

class _bEventsBarState extends State<bEventsBar> {
  @override
  void initState() {
    getEvents();
    // TODO: implement initState
    super.initState();
  }

  final List items = [
    "Luxary Abaya Collection",
    "Cultural Abaya Collection",
    "Premium Abaya Collection",
    "Luxary Abaya Collection"
  ];
  List<AddEventModel> events = [];

  getEvents() {
    try {
      events.clear();
      setState(() {});
      FirebaseFirestore.instance
          .collection("EventRegister")
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
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const addEvent(),
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
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemExtent: 290,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        events[index].image == null
                            ? Container(
                                height: 210,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image: NetworkImage(
                                            "https://d2x3xhvgiqkx42.cloudfront.net/12345678-1234-1234-1234-1234567890ab/651c25b0-2d60-43c8-addf-1df2fd575568/2021/08/16/455d8bde-5940-4005-a79a-56005926c158/65b4998a-5202-4a77-af1e-c646f5fc36e1.png"),
                                        fit: BoxFit.contain)),
                              )
                            : Container(
                                height: 210,
                                //   width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            events[index].image.toString()),
                                        fit: BoxFit.fill)),
                              ),
                        Positioned(
                            top: 140,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 77,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppColor.backgroundColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ReusableText(
                                        title: events[index].date,
                                        color: AppColor.primaryColor,
                                        size: 9,
                                        weight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const ReusableText(
                                        title: "31",
                                        color: AppColor.primaryColor,
                                        size: 18,
                                        weight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ReusableText(
                                        title: items[index],
                                        color: AppColor.blackColor,
                                        weight: FontWeight.bold,
                                        size: 8,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const ReusableText(
                                        title: "New York, US",
                                        color: AppColor.hintColor,
                                        size: 11,
                                        weight: FontWeight.bold,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
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
    );
  }
}
