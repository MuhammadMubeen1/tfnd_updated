import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tfnd_app/models/AddBusinessModel.dart';
import 'package:tfnd_app/models/AddEventModel.dart';
import 'package:tfnd_app/models/AddStoreModel.dart';
import 'package:tfnd_app/screens/auth/signin.dart';
import 'package:tfnd_app/screens/userSide/aEventDetail.dart';
import 'package:tfnd_app/screens/userSide/businessDetails.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

class homeBar extends StatefulWidget {
  String? curentuser;
  homeBar({super.key, required this.curentuser});

  @override
  State<homeBar> createState() => _homeBarState();
}

class _homeBarState extends State<homeBar> {
  @override
  void initState() {
    getEvents();
    getBusiness();
    getStores();
    getCurrentUserImage();

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

  List<AddStoreModel> stores = [];

  getStores() {
    try {
      stores.clear();
      setState(() {});
      FirebaseFirestore.instance
          .collection("Stores")
          .snapshots()
          .listen((event) {
        stores.clear();
        setState(() {});
        for (int i = 0; i < event.docs.length; i++) {
          AddStoreModel dataModel =
              AddStoreModel.fromJson(event.docs[i].data());
          stores.add(dataModel);

          print("my store == ${stores.length}");
        }
        setState(() {});
      });
      setState(() {});
    } catch (e) {}
  }

  bool isLoading = false;

  String? currentUserImage;
  getCurrentUserImage() async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection("RegisterUsers")
          .where("email", isEqualTo: widget.curentuser)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        currentUserImage = userSnapshot.docs[0].get("image");
        setState(() {});
      }
    } catch (e) {
      print("Error fetching current user's image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Image(
            image: AssetImage(
              "assets/images/tfnd.png",
            ),
            height: 80,
          ),
          actions: const [
            Icon(
              Icons.notifications,
              color: AppColor.hintColor,
              size: 28,
            ),
            SizedBox(
              width: 20,
            ),
          ],
          leading: currentUserImage != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/201/201634.png"),
                    radius: 20,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(""),
                    radius: 20,
                  ),
                ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  ReusableText(
                    title: "Events",
                    size: 16,
                    color: AppColor.darkTextColor,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 210,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      // childAspectRatio: 1.45,
                      mainAxisExtent: 350,
                      mainAxisSpacing: 30),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => eventsDetail(
                              event: events[index],
                              UserEmail: widget.curentuser.toString(),
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
                                      padding: const EdgeInsets.only(left: 25),
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
                                            size: 9,
                                            weight: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          ReusableText(
                                            title: events[index].date,
                                            color: AppColor.textColor,
                                            size: 10,
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
                                            size: 18,
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
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  ReusableText(
                    title: "Popular Stores",
                    color: AppColor.darkTextColor,
                    weight: FontWeight.bold,
                    size: 16,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                child: stores.isEmpty
                    ? Container() // Empty container when there are no businesses for more stores
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: stores.length,
                        itemBuilder: (context, index) {
                          if (businesses.isEmpty ||
                              index >= businesses.length) {
                            // Handle case when no businesses are available for the current store
                            return GestureDetector(
                              onTap: () {
                                // Display snackbar when no businesses are available
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: AppColor.pinktextColor,
                                    content: Text(
                                      'No business available for this store',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  stores[index].image == null ||
                                          stores[index].image!.isEmpty ||
                                          stores[index].image == ""
                                      ? const CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/store1.jpg"),
                                          radius: 35,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              stores[index].image.toString()),
                                          radius: 35,
                                        ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      businessDetails(
                                    business: businesses[index],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                stores[index].image == null ||
                                        stores[index].image!.isEmpty ||
                                        stores[index].image == ""
                                    ? const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/store1.jpg"),
                                        radius: 35,
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            stores[index].image.toString()),
                                        radius: 35,
                                      ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                children: [
                  ReusableText(
                    title: "Businesses",
                    color: AppColor.darkTextColor,
                    weight: FontWeight.bold,
                    size: 16,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 210,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: businesses.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 1.45),
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
                                          image: AssetImage(
                                              "assets/images/dp.jpg"),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: NetworkImage(businesses[index]
                                              .image
                                              .toString()),
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
              SizedBox(height: 10),
            ]),
          ),
        )));
  }
}
