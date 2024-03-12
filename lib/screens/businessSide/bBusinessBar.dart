import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/models/AddBusinessModel.dart';
import 'package:tfnd_app/screens/businessSide/addBusiness.dart';
import 'package:tfnd_app/screens/businessSide/businessDet.dart';
import 'package:tfnd_app/screens/userSide/businessDetails.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class bBusinessBar extends StatefulWidget {
  String emailuser;

  bBusinessBar({super.key, required this.emailuser});

  @override
  State<bBusinessBar> createState() => _bBusinessBarState();
}

class _bBusinessBarState extends State<bBusinessBar> {
  Stream<List<AddBusinessModel>>? businessStream;

  @override
  void initState() {
    super.initState();
    businessStream = getBusinessStream();
  }

  Stream<List<AddBusinessModel>> getBusinessStream() {
    return FirebaseFirestore.instance
        .collection("UniqueBusiness")
        .doc(widget.emailuser)
        .collection("Businesses")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddBusinessModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const ReusableText(
          title: "Business",
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
                        builder: (BuildContext context) => addBusiness(
                          useremail: widget.emailuser,
                        ),
                      ),
                    );
                  },
                  child: const Center(
                    child: ReusableText(
                      title: "Add New Business",
                      color: AppColor.pinktextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: StreamBuilder<List<AddBusinessModel>>(
                  stream: businessStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No businesses available.');
                    } else {
                      List<AddBusinessModel> businesses = snapshot.data!;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 30.0,
                          mainAxisExtent: 200,
                        ),
                        itemCount: businesses.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      businessDet(
                                    business: businesses[index],
                                    emaildetails: widget.emailuser,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/dp.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 130,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                businesses[index]
                                                    .image
                                                    .toString()),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
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
                      );
                    }
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
