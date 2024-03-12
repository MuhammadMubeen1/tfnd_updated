import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_outlined_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class CollectionModel {
  final String name;
  final String discount;
  //final String imageUrl;
  //final String uid;

  CollectionModel({
    required this.name,
    required this.discount,
    //required this.imageUrl,
    //   required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'discount': discount,
      // 'imageUrl': imageUrl,
      //'uid': uid
    };
  }
}

class AddCollections extends StatefulWidget {
  String idd;
  AddCollections({Key? key, required this.emailsuser, required this.idd});
  String emailsuser;

  @override
  State<AddCollections> createState() => _AddCollectionsState();
}

class _AddCollectionsState extends State<AddCollections> {
  TextEditingController nameController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  File? collectionPhoto;

  void initState() {
    super.initState();
    print(widget.toString());
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        collectionPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveCollectionData() async {
    if (collectionPhoto == null) {
      // Handle case where no photo is selected
      return;
    }

    // Upload the photo to Firebase Storage (you need to implement Firebase Storage handling)

    // Crea
    //
    //
    //te a CollectionModel instance
    CollectionModel collectionData = CollectionModel(
      name: nameController.text,
      discount: discountController.text,
      // imageUrl: imageUrl,
      // uid: id.toString(),
    );

    // Get the current user's email (you need to replace this with your authentication logic)

    // Save data to Firestore
    try {
      await FirebaseFirestore.instance
          .collection("UniqueBusiness")
          .doc(widget.emailsuser)
          .collection("Businesses")
          .doc(widget.idd)
          .collection("Collection")
          .add(collectionData.toJson());

      // Show success message or navigate to the next screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Collection data saved successfully!'),
        ),
      );
    } catch (e) {
      // Handle error
      print('Error saving collection data: $e');
    }
  }

  // You need to implement this method to upload the photo to Firebase Storage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.hintColor,
        ),
        centerTitle: true,
        title: const ReusableText(
          title: "Add Collection",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const ReusableText(
                  title: "Collection ",
                  color: AppColor.pinktextColor,
                  size: 17,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _showImagePicker(context);
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: collectionPhoto != null
                        ? Image.file(
                            collectionPhoto!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: ReusableText(
                              title: "Add Collection Images",
                              color: AppColor.pinktextColor,
                              size: 13,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReusableText(
                      title: "Collection Name",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextForm(
                      controller: nameController,
                      hintText: "Type Here",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 25,
                ),
                ReusableButton(
                  title: "Publish",
                  onTap: _saveCollectionData,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120.0,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo,
                  color: AppColor.pinktextColor,
                ),
                title: const Text(
                  'Gallery',
                ),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera,
                  color: AppColor.pinktextColor,
                ),
                title: const Text('Camera'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
