import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

class beditProfile extends StatefulWidget {
  const beditProfile({super.key});

  @override
  State<beditProfile> createState() => _beditProfileState();
}

class _beditProfileState extends State<beditProfile> {
  PickedFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor.hintColor,
        ),
        centerTitle: true,
        title: ReusableText(
          title: "Edit Profile",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: imageFile == null
                      ? GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => openGallery()),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                600), // Adjust the border radius as needed
                            child: Container(
                              height: 140,
                              width: 140,
                              child: Image.asset(
                                'assets/images/dp.jpg', // Replace 'assets/image.jpg' with your asset image path
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : ClipRRect(
                          child: Container(
                              height: 130,
                              width: 130,
                              child: Image.file(
                                File(imageFile!.path),
                                fit: BoxFit.cover,
                              )),
                          borderRadius: BorderRadius.circular(600),
                        ),
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableTextForm(
                  hintText: "Alize Zain",

                  // prefixIcon: Image(image: AssetImage("assets/icons/email.png")),
                  prefixIcon: Icon(
                    Icons.person_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ReusableTextForm(
                  hintText: "+92 337 88 33 498",
                  // prefixIcon: Image(image: AssetImage("assets/icons/email.png")),
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ReusableTextForm(
                  hintText: "alizezain123@gmail.com",
                  // prefixIcon: Image(image: AssetImage("assets/icons/email.png")),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ReusableTextForm(
                  hintText: "*************",

                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColor.hintColor,
                  ),
                  // prefixIcon: Image(image: AssetImage("assets/icons/email.png")),
                  prefixIcon: Icon(
                    Icons.password_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ReusableButton(title: "Update", onTap: () {}),
                SizedBox(
                  height: 20,
                )
              ],
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
        final bytes = Io.File(imageFile!.path).readAsBytesSync();

        // String img64 = base64Encode(bytes);
        // print(img64.substring(0, 100));
      });
    }
  }
}
