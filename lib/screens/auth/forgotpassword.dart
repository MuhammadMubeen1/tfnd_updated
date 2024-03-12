import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false; // Track loading state

  final CollectionReference resetPasswordCollection =
      FirebaseFirestore.instance.collection('RegisterUsers');

  Future<void> resetPassword() async {
    try {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      String email = emailController.text.trim();

      // TODO: Implement your logic to send the password reset link using Firebase Authentication.
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Save the reset request in Firestore
      await resetPasswordCollection.add({
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show a success message or navigate to a success screen
      print('Password reset request sent successfully');
      showSuccessSnackBar('Password reset request sent successfully');
    } catch (error) {
      // Handle errors, e.g., show an error message
      print('Error sending password reset request: $error');
      showErrorSnackBar('Error sending password reset request');
    } finally {
      setState(() {
        isLoading = false; // Set loading state back to false
      });
    }
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColor.pinktextColor,
      ),
    );
  }

  void showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(errorMessage), backgroundColor: AppColor.pinktextColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: AppColor.hintColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                    image: AssetImage("assets/images/forgotpassword.png")),
                const SizedBox(
                  height: 50,
                ),
                const ReusableText(
                  title: "Password Reset",
                  color: AppColor.pinktextColor,
                  size: 27,
                  weight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 15,
                ),
                const ReusableText(
                  textAlign: TextAlign.center,
                  title:
                      "If you need help resetting your password, we can help by sending you a link to reset it.",
                  color: AppColor.textColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                ReusableTextForm(
                  controller: emailController,
                  hintText: "Email",
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColor.hintColor,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                isLoading
                    ? const CircularProgressIndicator(
                        color: AppColor.pinktextColor,
                      ) // Show loading indicator
                    : ReusableButton(
                        title: "Send Request", onTap: resetPassword),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
