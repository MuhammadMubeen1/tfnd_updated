import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:tfnd_app/models/AddBusinessModel.dart';
import 'package:tfnd_app/models/BusinessCategory.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tfnd_app/const.dart';
import 'package:tfnd_app/screens/businessSide/addCollections.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_outlined_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';
import 'dart:io' as Io;

class addBusiness extends StatefulWidget {
  String useremail;
  addBusiness({super.key, required this.useremail});

  @override
  State<addBusiness> createState() => _addBusinessState();
}

class _addBusinessState extends State<addBusiness> {
  PickedFile? imageFile;

  UploadTask? task;
  String? firebasePictureUrl;
  bool isLoadFile = false;
  int? id;
  List<BusinessList> categories = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name should not be empty";
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return "Category should not be empty";
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return "Description should not be empty";
    }
    return null;
  }

  String? validateDiscount(String? value) {
    if (value == null || value.isEmpty) {
      return "Discount should not be empty";
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Date should not be empty";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    print(' user is ${widget.useremail} ');
  }

  int numberOfCollections = 3;
  BusinessRegister() async {
    isLoading = true;
    setState(() {});

    id = DateTime.now().millisecondsSinceEpoch;

    AddBusinessModel dataModel = AddBusinessModel(
      name: nameController.text,
      category: categoryController.text,
      image: firebasePictureUrl,
      description: descriptionController.text,
      discount: discountController.text,
      date: dateController.text,
      uid: id,
      email: widget.useremail,
    );

    try {
      await FirebaseFirestore.instance
          .collection("BusinessRegister")
          .doc('$id')
          .set(dataModel.toJson());

      // Add business to user-specific collection
      await FirebaseFirestore.instance
          .collection("UniqueBusiness")
          .doc(widget.useremail)
          .collection("Businesses")
          .doc('$id')
          .set(dataModel.toJson());

      // Create an additional collection inside $id

      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Business Created Successfully');
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

  getCategories() {
    try {
      categories.clear();
      setState(() {});
      FirebaseFirestore.instance
          .collection("BusinessCategory")
          .snapshots()
          .listen((event) {
        categories.clear();
        setState(() {});
        for (int i = 0; i < event.docs.length; i++) {
          BusinessList dataModel = BusinessList.fromJson(event.docs[i].data());
          categories.add(dataModel);

          print("my  catagories == ${categories.length}");
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
        iconTheme: const IconThemeData(
          color: AppColor.hintColor,
        ),
        centerTitle: true,
        title: const ReusableText(
          title: "Add Business",
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
                    ? const CircularProgressIndicator()
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
                                      title: "Add Business Image",
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
                      title: "Business Name",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextForm(
                      validator: validateName,
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
                      title: "Category",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogForTypes();
                      },
                      child: Container(
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColor.borderFormColor, width: 1),
                              borderRadius: BorderRadius.circular(18)),
                          child: ReusableTextForm(
                            enabled: false,
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            validator: validateCategory,
                            controller: categoryController,
                            hintText: "Select Here",
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReusableText(
                      title: "Description",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextForm(
                      validator: validateDescription,
                      controller: descriptionController,
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
                      title: "Discount Percent",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextForm(
                      validator: validateDate,
                      controller: discountController,
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
                      title: "Discount End Date ",
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
                  height: 25,
                ),
                Center(
                    child: ReusableOutlinedButton(
                        title: "Add Collections",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => AddCollections(
                                emailsuser: widget.useremail,
                                idd: id.toString(),
                              ),
                            ),
                          );
                        })),
                const SizedBox(
                  height: 25,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : ReusableButton(
                        title: "Publish",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            BusinessRegister();
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

  showDialogForTypes() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: titleForDialog(context, 'Select Category'),
            content: Container(
              // height: 200,
              width: 350,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Column(
                        children: [
                          Text(
                            //"fdlkjfkjdhjk"
                            categories[index].Category.toString(),
                          ),
                          const Divider(),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        categoryController.text =
                            categories[index].Category.toString();
                        setState(() {});
                        print(
                            "Tapped ${categories[index].Category.toString()}");
                      },
                    );
                  }),
            ),
          );
        });
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
