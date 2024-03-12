import 'dart:io';
import 'dart:io' as Io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:tfnd_app/const.dart';
import 'package:tfnd_app/models/AddEventModel.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:path/path.dart' as Path;
import 'package:search_map_location/search_map_location.dart';

import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class aAddEvent extends StatefulWidget {
  const aAddEvent({super.key});

  @override
  State<aAddEvent> createState() => _aAddEventState();
}

class _aAddEventState extends State<aAddEvent> {
  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController dicriptioncontrollor = TextEditingController();
  TextEditingController totalseatscontrollor = TextEditingController();
  TextEditingController pricecontrollor = TextEditingController();
  final initialPosition = LatLng(40.7128, -74.0060);

  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  PickedFile? imageFile;
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  LatLng? _pickedLocation;

  void _onLocationConfirmed() {
    Navigator.of(context).pop(_pickedLocation);
  }

  UploadTask? task;
  String? firebasePictureUrl;
  bool isLoadFile = false;

  EventRegister() async {
    isLoading = true;
    setState(() {});
    int id = DateTime.now().millisecondsSinceEpoch;
    AddEventModel dataModel = AddEventModel(
      name: nameController.text,
      discription: dicriptioncontrollor.text,
      slot: totalseatscontrollor.text,
      remaining: totalseatscontrollor.text,
      price: pricecontrollor.text,
      Location: locationController.text,
      image: firebasePictureUrl,
      date: dateController.text,
      time: timeController.text,
      uid: id,
    );
    try {
      await FirebaseFirestore.instance
          .collection('adminevents') // Use the collection name 'adminevents'
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

  showPlacePicker() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: "AIzaSyAlWLuEzszKgldMmuo9JjtKLxe9MGk75_k",
            hintText: "Select Location",
            searchingText: "Please wait ...",
            selectText: "Select place",
            outsideOfPickAreaText: "Place is not in area",
            initialPosition: initialPosition,
            selectInitialPosition: true,
            onPlacePicked: (result) {
              locationController.text = result.formattedAddress!;
              // addressLatLng = LatLng(
              //     result.geometry!.location.lat, result.geometry!.location.lng);
              //  latitude = result.geometry!.location.lat;
              //  longitude = result.geometry!.location.lng;

              Navigator.of(context).pop();
              setState(() {});
            },
          );
        },
      ),
    );
    setState(() {});
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
                                      title: "Add Event Image",
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
                      title: "Description",
                      color: AppColor.textColor,
                      size: 12,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ReusableTextForm(
                      controller: dicriptioncontrollor,
                      hintText: "Type Here",
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ReusableText(
                            title: "Total Slots",
                            color: AppColor.textColor,
                            size: 12,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableTextForm(
                            controller: totalseatscontrollor,
                            hintText: "Add Here",
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ReusableText(
                            title: "Price",
                            color: AppColor.textColor,
                            size: 12,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableTextForm(
                            controller: pricecontrollor,
                            hintText: "00",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
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
                                      color: AppColor.borderFormColor,
                                      width: 1),
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
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ReusableText(
                            title: "Event Time",
                            color: AppColor.textColor,
                            size: 12,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showTimePicker();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.borderFormColor,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(18)),
                              child: ReusableTextForm(
                                controller: timeController,
                                enabled: false,
                                suffixIcon: const Icon(
                                  Icons.alarm_outlined,
                                  color: AppColor.primaryColor,
                                ),
                                hintText: "Pick Time",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const ReusableText(
                    title: "Location",
                    color: AppColor.textColor,
                    size: 12,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: locationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'Pick Location',
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          showPlacePicker();
                        },
                        child: const Icon(
                          Icons.location_on,
                          color: AppColor.pinktextColor,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 35,
                ),
                isLoading
                    ? const CircularProgressIndicator()
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
