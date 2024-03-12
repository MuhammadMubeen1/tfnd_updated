import 'dart:io';
import 'dart:io' as Io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tfnd_app/const.dart';
import 'package:tfnd_app/models/AddEventModel.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:path/path.dart' as Path;

class addEvent extends StatefulWidget {
  const addEvent({super.key});

  @override
  State<addEvent> createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  PickedFile? imageFile;

  UploadTask? task;
  String? firebasePictureUrl;
  bool isLoadFile = false;

  EventRegister() async {
    isLoading = true;
    setState(() {});
    int id = DateTime.now().millisecondsSinceEpoch;
    AddEventModel dataModel = AddEventModel(
      name: nameController.text,
      image: firebasePictureUrl,
      date: dateController.text,
      uid: id,
    );
    try {
      await FirebaseFirestore.instance
          .collection(StaticInfo.eventRegister)
          .doc('$id')
          .set(dataModel.toJson());
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Event Created Successfully');
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
        iconTheme: const IconThemeData(
          color: AppColor.hintColor,
        ),
        centerTitle: true,
        title: const ReusableText(
          title: "Add Event",
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
                const SizedBox(
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
                                  child: const Center(
                                    child: ReusableText(
                                      title: "Add Event Photo",
                                      color: AppColor.pinktextColor,
                                      size: 13,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 175,
                                width: double.infinity,
                                child: Image.file(
                                  File(imageFile!.path),
                                  fit: BoxFit.cover,
                                )),
                      ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReusableText(
                      title: "Event Name",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
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
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReusableText(
                      title: "Location",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.borderFormColor, width: 1),
                          borderRadius: BorderRadius.circular(18)),
                      child: ReusableTextForm(
                        enabled: false,
                        controller: locationController,
                        suffixIcon: const Icon(
                          Icons.pin_drop,
                          color: AppColor.primaryColor,
                        ),
                        hintText: "Select Location",
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReusableText(
                      title: "Event Date",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        selectDate(context, 0);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColor.borderFormColor, width: 1),
                            borderRadius: BorderRadius.circular(18)),
                        child: ReusableTextForm(
                          controller: dateController,
                          enabled: false,
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            color: AppColor.primaryColor,
                          ),
                          hintText: "Pick Date",
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : ReusableButton(
                        title: "Publish",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            EventRegister();
                          }
                        }),
                const SizedBox(
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Chose profile photo",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          const SizedBox(
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
                child: const Row(
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
                child: const Row(
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

  selectDate(BuildContext context, int index) async {
    DateTime? selectDate;
    await DatePicker.showDatePicker(context,
        showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
      selectDate = date;
    }, currentTime: DateTime.now());
    if (selectDate != null) {
      setState(() {
        if (index == 0) {
          dateController.text =
              DateFormat('dd-MM-yyyy KK:MM a').format(selectDate!);
        }
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
