import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tfnd_app/const.dart';
import 'package:tfnd_app/models/AddUserModel.dart';
import 'package:tfnd_app/screens/auth/signin.dart';
import 'package:tfnd_app/screens/businessSide/bBottomnavbar.dart';
import 'package:tfnd_app/screens/userSide/business_request/user_request.dart';
import 'package:tfnd_app/screens/userSide/editProfile.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:tfnd_app/widgets/reusable_outlined_button.dart';
import 'package:http/http.dart' as http;
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

class profileBar extends StatefulWidget {
  String currentUserEmail;

  profileBar({
    Key? key,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  State<profileBar> createState() => _profileBarState();
}

class _profileBarState extends State<profileBar> {
  late Future<AddUserModel?> userDataFuture;
  //var currentUser;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
  }

  var curentUser;
  AddUserModel? userData;
  bool _obscureText = true;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    initializeLocalNotifications();

    userDataFuture = getUserData(widget.currentUserEmail);
    getRequestStatus(widget.currentUserEmail);
  }

  void initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  String? status;

  Future<void> getRequestStatus(String currentUserEmail) async {
    try {
      QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('curentemail', isEqualTo: currentUserEmail)
          .get();

      if (requestSnapshot.docs.isNotEmpty) {
        // Assuming 'status' is the field you want to retrieve
        status = requestSnapshot.docs.first['status'];

        if (status == "approve") {
        } else {}

        print('Request Status: $status');
      } else {
        print('No request found for the current user.');
      }
    } catch (e) {
      print('Error fetching request status: $e');
    }
  }

  Future<AddUserModel?> getUserData(String currentUserEmail) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('RegisterUsers')
          .where('email', isEqualTo: currentUserEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        userData = AddUserModel.fromJson(
            userSnapshot.docs.first.data() as Map<String, dynamic>);

        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

///////////////////////stripe payment method/////////////////////////

  Map<String, dynamic>? paymentIntent;
  var SECRET_KEY =
      'sk_test_51MRaTJF6Z1rhh5U4coAffyEf0hQrV820sQzwuAo7xBKpvGw0mBaz6pNCBtXrZoYTJZxH9uIZCxK7rEAKUKK3VZPA00pGIqUKA1';

  Future<void> makePay() async {
    try {
      paymentIntent = await createPaymentIntent('50', 'AED');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'mubeen'))
          .then((value) {});

      displayPaymentSheet();
      savePaymentDetails();
      updateUserProfile();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  // Function to display the payment sheet
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfully"),
                        ],
                      ),
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  // Function to create a payment intent using Stripe API
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  // Function to calculate the payment amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const ReusableText(
          title: "Profile",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Editprofile(
                    image: userData!.image.toString(),
                    phonenumber: userData!.phoneNumber.toString(),
                    password: userData!.password.toString(),
                    name: userData!.name.toString(),
                    eamil: userData!.email.toString(),
                  ),
                ),
              );
            },
            child: const ImageIcon(AssetImage("assets/icons/edit.png")),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder<AddUserModel?>(
              future: userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.pinktextColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  userData = snapshot.data!;

                  // name.text = userData.name.toString();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      CircleAvatar(
                        backgroundImage: userData!.image != null
                            ? AssetImage("assets/images/pic2.png")
                                as ImageProvider<Object>?
                            : const AssetImage("assets/images/pic2.png"),
                        radius: 70,
                      ),
                      const SizedBox(height: 30),
                      ReusableTextForm(
                        readOnly: true,
                        hintText: userData!.name,
                        prefixIcon: const Icon(
                          Icons.person_outlined,
                          color: AppColor.hintColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ReusableTextForm(
                        readOnly: true,
                        hintText: userData!.phoneNumber,
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: AppColor.hintColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ReusableTextForm(
                        readOnly: true,
                        hintText: userData!.email,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColor.hintColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ReusableTextForm(
                        readOnly: true,
                        obscureText: !_passwordVisible,
                        hintText:
                            _passwordVisible ? '........' : userData!.password,
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

                      const SizedBox(height: 20),
                      // ReusableButton(
                      //   title: "Get Subcription for discounts",
                      //   onTap: () {
                      //     showSubscriptionPopup();
                      //   },
                      // ),
                      const SizedBox(height: 10),
                      ReusableOutlinedButton(
                        title: _getButtonTitle(),
                        onTap: () {
                          _handleButtonTap();
                        },
                      ),
                      const SizedBox(height: 10),
                      ReusableOutlinedButton(
                        title: "Log Out",
                        onTap: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => signin(),
                              ),
                            );
                          } catch (e) {
                            print("Error signing out: $e");
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showSubscriptionPopup() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10), // Adjust content padding
          title: const Center(
            child: Text(
              "Subscribe Now  ",
              style: TextStyle(
                  color: AppColor.darkTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
              children: [
                const Text(
                  "Pay AED 50",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pinktextColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Get access for one month",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "After getting a membership, You can scan the QR code for discounts three times in a month.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColor.textColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    await makePay();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40, // Decrease the height of the button
                    width: 200, // Decrease the width of the button
                    decoration: BoxDecoration(
                      color: AppColor.pinktextColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Get Discounts Now!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text(
                "Close",
                style: TextStyle(
                  color: AppColor.pinktextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  savePaymentDetails() async {
    try {
      print("user data =${userData}");
      if (userData != null) {
        await FirebaseFirestore.instance.collection('Subcribeduser').add({
          'userName': userData!.name.toString(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        const SnackBar(
          padding: EdgeInsets.all(10),
          backgroundColor: AppColor.textColor,
          content: Text(
            'Subscribed user Successfully!',
            style: TextStyle(color: AppColor.pinktextColor),
          ),
          duration: Duration(seconds: 2),
        );
      }
    } catch (error) {
      print('Error saving payment details: $error');
      setState(() {});
    }
  }

  Future<void> updateUserProfile() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('RegisterUsers')
          .where('email', isEqualTo: userData!.email.toString())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        await doc.reference.update({
          'subscription': 'paid', // Change subscription to "paid"

          // You can add more fields if needed
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
        // isLoading = false;
      });
    }
  }

  String _getButtonTitle() {
    if (status == null) {
      return "Request to add business"; // Replace with your desired text
    } else if (status == "pending") {
      return "My Business"; // Replace with your desired text
    } else if (status == "approve") {
      return "My Business"; // Replace with your desired text
    } else {
      return "My Business"; // Replace with your desired default text
    }
  }

  void _handleButtonTap() {
    if (status == null) {
      _showPending();
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => Requestform(
            emails: widget.currentUserEmail,
          ),
        ),
      );
    } else if (status == "pending") {
      _showPendingSnackbar();
      // Handle the button tap for pending status
      // You can add your logic here
    } else if (status == "approve") {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => bBottomnavbar(
            currentuser: widget.currentUserEmail,
          ),
        ),
      );
      // Handle the button tap for approval status
      // You can add your logic here
    } else {
      // Handle the button tap for other statuses or provide a default behavior
      // You can add your logic here
    }
  }

  void _showPendingSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColor.pinktextColor,
        content: Text(
          'Your Business Request is pending! ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  void _showPending() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColor.pinktextColor,
        content: Text(
          'Send request to admin for business! ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  void _showApprovalNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Change this to your channel ID
      'Your Channel Name',

      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      'Business Approved',
      'Your business request has been approved!',
      platformChannelSpecifics,
    );
  }
}
