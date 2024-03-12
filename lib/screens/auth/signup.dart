import 'package:flutter/material.dart';
import 'package:tfnd_app/const.dart';
import 'package:tfnd_app/models/AddUserModel.dart';
import 'package:tfnd_app/screens/auth/signin.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RegisterUser() async {
    setState(() {
      isLoading = true;
    });
    int id = DateTime.now().millisecondsSinceEpoch;
    AddUserModel dataModel = AddUserModel(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      subscription: "unpaid",
      phoneNumber: phoneController.text,
      isBusiness: 'false',
      image:
          "https://images.unsplash.com/photo-1618641986557-1ecd230959aa?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
      uid: id,
    );
    try {
      await FirebaseFirestore.instance
          .collection(StaticInfo.registerUser)
          .doc('$id')
          .set(dataModel.toJson());
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Account Created Successfully');
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const signin(),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Some Error Occurred');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const ReusableText(
                    title: "Sign Up",
                    color: AppColor.pinktextColor,
                    size: 27,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ReusableTextForm(
                    controller: nameController,
                    hintText: "Full Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Business name cannot be empty';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(
                      Icons.person_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableTextForm(
                    controller: phoneController,
                    hintText: "Phone",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "please enter phone number";
                      } else {
                        return null;
                      }
                    },
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableTextForm(
                    controller: emailController,
                    hintText: "Email",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "this field is required";
                      } else if (!v.contains("@")) {
                        return "email badly formatted";
                      } else {
                        return null;
                      }
                    },
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableTextForm(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: !_passwordVisible,
                    suffixIcon: IconButton(
                      // Toggle icon based on password visibility
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColor.hintColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Password Should Not Be Empty";
                      } else {
                        return null;
                      }
                    },
                    prefixIcon: const Icon(
                      Icons.password_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: AppColor.pinktextColor,
                        )
                      : ReusableButton(
                          title: "Register",
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              RegisterUser();
                            }
                          },
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ReusableText(
                        title: "Already have an account?",
                        color: AppColor.textColor,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => const signin(),
                            ),
                          );
                        },
                        child: const ReusableText(
                          title: "   Sign In",
                          color: AppColor.pinktextColor,
                          weight: FontWeight.w900,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
