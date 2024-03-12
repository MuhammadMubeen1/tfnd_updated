import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfnd_app/adminSide/buttom_navigation.dart';
import 'package:tfnd_app/const.dart';
import 'package:tfnd_app/screens/auth/forgotpassword.dart';
import 'package:tfnd_app/screens/auth/signup.dart';
import 'package:tfnd_app/screens/userSide/bottomnavbar.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  userLogin() async {
    isLoading = true;
    setState(() {});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool userNameExists;
    bool passwordExists;
    bool adminExist;
    bool adminPasswordExist;
    try {
      var authResult = await FirebaseFirestore.instance
          .collection(StaticInfo.registerUser)
          .where('email', isEqualTo: emailController.text)
          .get();

      var adminResult = await FirebaseFirestore.instance
          .collection("Admin")
          .where(
            'email',
            isEqualTo: emailController.text.toLowerCase(),
          )
          .get();
      userNameExists = authResult.docs.isNotEmpty;
      adminExist = adminResult.docs.isNotEmpty;
      if (userNameExists) {
        var authResult = await FirebaseFirestore.instance
            .collection(StaticInfo.registerUser)
            .where('password', isEqualTo: passwordController.text.toLowerCase())
            .get();

        passwordExists = authResult.docs.isNotEmpty;
        if (passwordExists) {
          await preferences.setBool('isLoggedIn', true);
          String userName = authResult.docs[0]["name"];

          await preferences.setString('username', userName);
          await preferences.setString('email', emailController.text.trim());
          await preferences.setString(
              'password', passwordController.text.trim());
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: 'Successfully logged in');
          //NavigateToHome
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavBar(
                      userEmail: emailController.text,
                      status: '',
                    )),
          );
        } else {
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: 'Incorrect username or password');
        }
      } else if (adminExist) {
        var adminResult = await FirebaseFirestore.instance
            .collection("Admin")
            .where('password', isEqualTo: passwordController.text)
            .get();
        adminPasswordExist = adminResult.docs.isNotEmpty;
        if (adminPasswordExist) {
          await preferences.setString('email', emailController.text.trim());
          await preferences.setString(
              'password', passwordController.text.trim());
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: 'Successfully logged in');
          //NavigateToHome
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Buttomnavigation()),
          );
        } else {
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: 'Incorrect username or password');
        }
      } else {
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'Incorrect username or password');
      }
    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Some error occurred');
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPass = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                    height: 50,
                  ),
                  Container(
                    height: 250,
                    width: 250,
                    child: Image(image: AssetImage("assets/images/tfnd.png")),
                  ),
                  const ReusableText(
                    title: "Sign In",
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
                        "Enter your email address and password to access your account",
                    color: AppColor.textColor,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ReusableTextForm(
                    controller: emailController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "this field is required";
                      } else if (!v.contains("@")) {
                        return "email badly formatted";
                      } else {
                        return null;
                      }
                    },
                    hintText: "Email",
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ReusableTextForm(
                    obscureText: !_passwordVisible,
                    controller: passwordController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Password Should Not Be Empty";
                      } else {
                        return null;
                      }
                    },
                    hintText: "Password",
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
                    prefixIcon: const Icon(
                      Icons.password_outlined,
                      color: AppColor.hintColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const ForgotPassword(),
                            ),
                          );
                        },
                        child: const ReusableText(
                          title: "Forgot Password?",
                          color: AppColor.pinktextColor,
                          weight: FontWeight.w900,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: AppColor.pinktextColor,
                        )
                      : ReusableButton(
                          title: "Sign In",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              userLogin();
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
                        title: "Create a new account?",
                        color: AppColor.textColor,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => const signup(),
                            ),
                          );
                        },
                        child: const ReusableText(
                          title: "   Sign Up",
                          color: AppColor.pinktextColor,
                          weight: FontWeight.w900,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
