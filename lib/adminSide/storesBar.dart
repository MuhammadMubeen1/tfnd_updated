import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/adminSide/addStore.dart';
import 'package:tfnd_app/models/AddStoreModel.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class StoresBar extends StatefulWidget {
  const StoresBar({super.key});

  @override
  State<StoresBar> createState() => _StoresBarState();
}

class _StoresBarState extends State<StoresBar> {
  @override
  void initState() {
    getStores();
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: ReusableText(
          title: "Stores",
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
            SizedBox(
              height: 10,
            ),
            Container(
              height: 55,
              width: double.infinity,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColor.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const addStore(),
                      ),
                    );
                  },
                  child: Center(
                    child: ReusableText(
                      title: "Add New Store",
                      color: AppColor.pinktextColor,
                    ),
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisExtent: 200),
                itemCount: stores.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      stores[index].image == null ||
                              stores[index].image!.isEmpty ||
                              stores[index].image == ""
                          ? Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: const DecorationImage(
                                      image: AssetImage("assets/images/dp.jpg"),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          stores[index].image.toString()),
                                      fit: BoxFit.cover)),
                            ),
                      const SizedBox(
                        height: 7,
                      ),
                      ReusableText(
                        title: stores[index].name,
                        color: AppColor.darkTextColor,
                        size: 12,
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
