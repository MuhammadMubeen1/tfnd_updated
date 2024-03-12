import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class Editprofile extends StatefulWidget {
  final String eamil, phonenumber, name, password, image;

  Editprofile({
    Key? key,
    required this.eamil,
    required this.phonenumber,
    required this.name,
    required this.password,
    required this.image,
  }) : super(key: key);

  @override
  State<Editprofile> createState() => _ProfileBarState();
}

class _ProfileBarState extends State<Editprofile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  PickedFile? imageFile;
  String profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _nameController.text = widget.name;
    _phoneNumberController.text = widget.phonenumber;
    _emailController.text = widget.eamil.toString();
    _passwordController.text = widget.password;
    profilePicUrl = widget.image;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
              color: AppColor.pinktextColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        actions: [],
      ),
      body: SafeArea(
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
                          borderRadius: BorderRadius.circular(600),
                          child: Container(
                            height: 140,
                            width: 140,
                            child: (imageFile != null)
                                ? Image.file(
                                    File(imageFile!.path),
                                    fit: BoxFit.cover,
                                  )
                                : (profilePicUrl.isEmpty
                                    ? Image.asset(
                                        'assets/images/pic2.png',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/pic2.png',
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
                  controller: _nameController,
                  hintText: "Name",
                  prefixIcon: const Icon(
                    Icons.person_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(height: 20),
                ReusableTextForm(
                  controller: _phoneNumberController,
                  hintText: "Phone Number",
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(height: 20),
                ReusableTextForm(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(height: 20),
                ReusableTextForm(
                  controller: _passwordController,
                  hintText: "Password",
                  suffixIcon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColor.hintColor,
                  ),
                  prefixIcon: const Icon(
                    Icons.password_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      textStyle: const TextStyle(fontSize: 18),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () async {
                      if (imageFile != null) {
                        await uploadProfilePicture();
                      }
                      updateUserProfile();
                    },
                    child: isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              Text(
                                "Please Wait...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            "Update Profile",
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

  Future<void> uploadProfilePicture() async {
    try {
      String downloadUrl = await uploadImageToStorage(imageFile!.path);
      setState(() {
        profilePicUrl = downloadUrl;
      });
    } catch (error) {
      print('Error uploading profile picture: $error');
      // Handle error as needed
    }
  }

  Future<void> updateUserProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('RegisterUsers')
          .where('email', isEqualTo: widget.eamil.toString())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        await doc.reference.update({
          'name': _nameController.text.isEmpty || _nameController.text == null
              ? widget.name
              : _nameController.text,
          'phoneNumber': _phoneNumberController.text.isEmpty ||
                  _phoneNumberController.text == null
              ? widget.phonenumber
              : _phoneNumberController.text,
          'email':
              _emailController.text.isEmpty || _emailController.text == null
                  ? widget.eamil
                  : _emailController.text,
          'password': _passwordController.text.isEmpty ||
                  _passwordController.text == null
              ? widget.password
              : _passwordController.text,
          'image': profilePicUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found!'),
          ),
        );
      }
    } catch (error) {
      print('Error updating profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
