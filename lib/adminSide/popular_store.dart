import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class Papularstore extends StatefulWidget {
  @override
  State<Papularstore> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<Papularstore> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImageToFirestore() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColor.pinktextColor,
            content: Text(
              'Please select an image to upload.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        );
        return; // Exit the method if no image is selected
      }

      // Upload image to Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('store_images/${DateTime.now()}.png');
      final TaskSnapshot uploadTask = await storageReference.putFile(_image!);
      final String downloadURL = await uploadTask.ref.getDownloadURL();

      // Store download URL and text field information in Firestore
      await FirebaseFirestore.instance.collection('stores').add({
        'imageURL': downloadURL,
        'textFieldInfo': _controller.text,
      });

      // Clear the image and text field after uploading
      setState(() {
        _image = null;
        _controller.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColor.pinktextColor,
          content: Text(
            'Upload Store successful!',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
    } catch (error) {
      print('Upload Store Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColor.pinktextColor,
          content: Text(
            'Store Upload Failed. Please try again.',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.hintColor,
        ),
        title: const Center(
          child: Text(
            'Store',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppColor.pinktextColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 150,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Pick Image",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.hintColor,
                                fontSize: 20),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(
                                    Icons.image,
                                    color: AppColor.pinktextColor,
                                  ),
                                  title: const Text(
                                    "Pick from Gallery",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.hintColor,
                                        fontSize: 16),
                                  ),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                const SizedBox(height: 10),
                                ListTile(
                                  leading: const Icon(
                                    Icons.camera_alt,
                                    color: AppColor.pinktextColor,
                                  ),
                                  title: const Text(
                                    "Take a Picture",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.hintColor,
                                        fontSize: 16),
                                  ),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 167,
                    width: 338,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor.hintColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        if (_image != null)
                          Center(
                            child: Image.file(
                              _image!,
                              fit: BoxFit.fill,
                              height: 150,
                              width: 300,
                            ),
                          )
                        else
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload,
                                  size: 50.0,
                                  color: AppColor.hintColor,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Upload Store",
                                  style: TextStyle(
                                    color: AppColor.hintColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ReusableTextForm(
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "This field is required";
                    } else {
                      return null;
                    }
                  },
                  controller: _controller,
                  hintText: "Enter info",
                  prefixIcon: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    textStyle: const TextStyle(fontSize: 18),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _uploadImageToFirestore();
                    }
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
                          "Upload Store",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
}
