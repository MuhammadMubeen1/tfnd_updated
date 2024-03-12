import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfnd_app/themes/color.dart';

class UploadadsScreen extends StatefulWidget {
  @override
  State<UploadadsScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<UploadadsScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  final picker = ImagePicker();
  File? _image;

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
        return;
      }

      // Upload image to Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('store_images/${DateTime.now()}.png');
      final TaskSnapshot uploadTask = await storageReference.putFile(_image!);
      final String downloadURL = await uploadTask.ref.getDownloadURL();

      // Store download URL and text field information in Firestore
      await FirebaseFirestore.instance.collection('Ads').add({
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
            'Upload Ads successful!',
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
            'Store Ads Failed. Please try again.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.hintColor,
        ),
        title: const Center(
            child: Text(
          'Ads',
          style: TextStyle(
              color: AppColor.pinktextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        style: TextStyle(fontWeight: FontWeight.w500),
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
                              "Upload Ads",
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
            const SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () async {
                await _uploadImageToFirestore();
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
                      "Upload Ads",
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
    );
  }
}
