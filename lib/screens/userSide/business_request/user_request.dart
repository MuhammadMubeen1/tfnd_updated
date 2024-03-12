import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Requestform extends StatefulWidget {
  String emails;
  Requestform({Key? key, required this.emails}) : super(key: key);

  @override
  State<Requestform> createState() => _ProfileBarState();
}

class _ProfileBarState extends State<Requestform> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final initialPosition = LatLng(40.7128, -74.0060);

  bool isLoading = false;
  PickedFile? imageFile;
  String profilePicUrl = "";
  final _formKey = GlobalKey<FormState>();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    var android = AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSettings = InitializationSettings(
      android: android,
    );
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
    );
  }

  Future onSelectNotification(String? payload) async {
    // Handle notification tap
    print("Notification tapped");
  }

  Future<String> uploadImageToStorage(String filePath) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('user_profile_pictures')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    final UploadTask uploadTask = storageReference.putFile(File(filePath));
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> sendRequestToFirestore(String imageUrl) async {
    try {
      CollectionReference requestsCollection =
          FirebaseFirestore.instance.collection('requests');

      DocumentReference requestDocument = await requestsCollection.add({
        'userName': _nameController.text,
        'phone': _phoneNumberController.text,
        'email': _emailController.text,
        'location': locationController.text,
        'imageUrl': imageUrl,
        'status': 'pending',
        'curentemail': widget.emails,
        // Initial status
      });

      String requestId = requestDocument.id;
      await requestDocument.update({'requestId': requestId});

      print('Request sent successfully with ID: $requestId');
    } catch (error) {
      print('Error sending request to Firestore: $error');
    }
  }

  void handleRequestStatus(String requestId, String status) async {
    try {
      CollectionReference requestsCollection =
          FirebaseFirestore.instance.collection('requests');

      await requestsCollection.doc(requestId).update({'status': status});

      if (status == 'approved') {
        // Show notification when the status is approved
      }

      print('Request $requestId $status successfully');
    } catch (error) {
      print('Error updating request status: $error');
    }
  }

  Future<void> uploadProfilePicture() async {
    try {
      if (imageFile == null) {
        // Show a Snackbar if the image is null
        Fluttertoast.showToast(
          msg: 'Please select a business image',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return; // Exit the function if the image is null
      }

      String downloadUrl = await uploadImageToStorage(imageFile!.path);

      await sendRequestToFirestore(downloadUrl);

      // Show a Snackbar when the request is sent successfully
      Fluttertoast.showToast(
        msg: 'Request sent successfully. You will be notified.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: AppColor.pinktextColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Clear the form fields
      _nameController.clear();
      _phoneNumberController.clear();
      _emailController.clear();
      locationController.clear();
      setState(() {
        imageFile = null;
      });
    } catch (error) {
      print('Error uploading profile picture: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Business Request",
          style: TextStyle(
              color: AppColor.pinktextColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => openGallery()),
                      );
                    },
                    child: Center(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 140,
                              width: double.infinity,
                              child: (imageFile != null)
                                  ? Image.file(
                                      File(imageFile!.path),
                                      fit: BoxFit.contain,
                                    )
                                  : (profilePicUrl.isEmpty
                                      ? Container(
                                          height: 150,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200),
                                          child: Center(
                                            child: ReusableText(
                                              title: "Add Business Image",
                                            ),
                                          ),
                                        )
                                      : Image.network(
                                          profilePicUrl,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => openGallery()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: AppColor.hintColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ReusableTextForm(
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Please enter business Name";
                      } else {
                        return null;
                      }
                    },
                    controller: _nameController,
                    hintText: "Business Name",
                    prefixIcon: const Icon(
                      Icons.person_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ReusableTextForm(
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Please enter Phone Number";
                      } else {
                        return null;
                      }
                    },
                    controller: _phoneNumberController,
                    hintText: "Phone Number",
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ReusableTextForm(
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Please enter email";
                      } else {
                        return null;
                      }
                    },
                    controller: _emailController,
                    hintText: "Email",
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        TextFormField(
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Please enter location";
                            } else {
                              return null;
                            }
                          },
                          onTap: () {
                            showPlacePicker();
                          },
                          readOnly: true,
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
                            suffixIcon: const Icon(
                              Icons.location_on,
                              color: AppColor.pinktextColor,
                              size: 25,
                            ),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 20),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        textStyle: const TextStyle(fontSize: 18),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading =
                              true; // Set isLoading to true before starting the operation
                        });

                        // Call the uploadProfilePicture function
                        if (_formKey.currentState!.validate()) {
                          await uploadProfilePicture();

                          // Set isLoading back to false once the operation is completed
                          setState(() {
                            isLoading = false;
                          });
                        }

                        // Optionally, you can also navigate to another screen or perform additional actions here.
                      },
                      child:
                          // isLoading
                          //     ? const Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           CircularProgressIndicator(
                          //             color: Colors.white,
                          //           ),
                          //           SizedBox(
                          //             width: 24,
                          //           ),
                          //           Text(
                          //             "Please Wait...",
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //         ],
                          //       )
                          //     :
                          const Text(
                        "Submit Business",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
            "Choose profile photo",
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
                  takePhoto(ImageSource.camera);
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
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

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
}
