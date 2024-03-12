import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io' as Io;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tfnd_app/const.dart';
import 'package:tfnd_app/models/AddStoreModel.dart';
import 'package:tfnd_app/models/BusinessCategory.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';
import 'package:path/path.dart' as Path;

class addStore extends StatefulWidget {
  const addStore({super.key});

  @override
  State<addStore> createState() => _addStoreState();
}

class _addStoreState extends State<addStore> {
  PickedFile? imageFile;

  UploadTask? task;
  String? firebasePictureUrl;
  bool isLoadFile = false;

  List<BusinessList> categories = [];

  String? selectedValue;
  String? selectedValue1;

  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  StoreRegister() async {
    isLoading = true;
    setState(() {});
    int id = DateTime.now().millisecondsSinceEpoch;
    AddStoreModel dataModel = AddStoreModel(
      name: nameController.text,
      image: firebasePictureUrl,
      uid: id,
    );
    try {
      await FirebaseFirestore.instance
          .collection("Stores")
          .doc('$id')
          .set(dataModel.toJson());
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Store Created Successfully');
      Navigator.pop(context);
    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Some Error Occurred');
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  // bool isPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor.hintColor,
        ),
        centerTitle: true,
        title: ReusableText(
          title: "Add Store",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                isLoadFile
                    ? CircularProgressIndicator()
                    : Center(
                        child: imageFile == null
                            ? GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => openGallery()),
                                  );
                                },
                                child: Container(
                                  height: 55,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: AppColor.primaryColor)),
                                  child: Center(
                                    child: ReusableText(
                                      title: "Add Store Photo",
                                      color: AppColor.pinktextColor,
                                      size: 13,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 150,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    File(imageFile!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                      ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      title: "Store Name",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ReusableTextForm(
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Name should not be Empty";
                        } else {
                          return null;
                        }
                      },
                      controller: nameController,
                      hintText: "Type Here",
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : ReusableButton(
                        title: "Publish",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            StoreRegister();
                          }
                        }),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget openGallery() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Chose profile photo",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  takePhoto(
                    ImageSource.camera,
                  );
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Text("Camera "),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.camera_alt),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Text("Gallery "),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.image),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(
      source: source,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        uploadFile();
        final bytes = Io.File(imageFile!.path).readAsBytesSync();

        // String img64 = base64Encode(bytes);
        // print(img64.substring(0, 100));
      });
    }
  }

  //Function for uploading picture to firestore
  Future uploadFile() async {
    setState(() {
      isLoadFile = true;
    });
    if (imageFile == null) return;
    final fileName = Path.basename(imageFile!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, File(imageFile!.path));
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    firebasePictureUrl = urlDownload;
    setState(() {
      isLoadFile = false;
    });
  }
}
