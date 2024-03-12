import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tfnd_app/models/AddUserModel.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_button.dart';
import 'package:http/http.dart' as http;

class Scanner extends StatefulWidget {
  Scanner(this.email, {Key? key}) : super(key: key);
  String email;

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<Scanner> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  bool isDialogOpen = false;
  int scanCounter = 0;
  DateTime? lastScanTimestamp;
  AddUserModel? userData;
  Map<String, dynamic>? paymentIntent;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? isPaid;

  Future<AddUserModel?> getUserData(String currentUserEmail) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('RegisterUsers')
          .where('email', isEqualTo: currentUserEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = AddUserModel.fromJson(
            userSnapshot.docs.first.data() as Map<String, dynamic>);

        if (userData.subscription!.isNotEmpty) {
          isPaid = userData.subscription;
          setState(() {
            isPaid;
          });
          print("if working status is ${isPaid}");
        } else {
          print("else working ${isPaid}");
        }

        return userData; // Return the fetched user data
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeScanner();
  }

  Future<void> initializeScanner() async {
    await getUserData(widget.email);
    print("status is $isPaid");
    print("email is ${widget.email}");
    setState(() {
      // Trigger a rebuild with the updated information
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Image(
            image: AssetImage(
              "assets/images/tfnd.png",
            ),
            height: 80,
          ),
          // title: Text(
          //   isPaid == "paid" ? ' paid' : "unpaid",
          //   style: const TextStyle(
          //     color: AppColor.pinktextColor,
          //     fontSize: 19,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
        ),
        body: isPaid == "paid"
            ? Column(
                children: <Widget>[
                  const Text(
                    "Please Scan QR Code of the\nstore to avail discount.",
                    textAlign: TextAlign.center, // Align text to the center
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors
                          .pink, // Assuming AppColor.pinktextColor is a Color variable
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(flex: 4, child: _buildQrView(context)),
                  const SizedBox(height: 20),
                ],
              )
            : Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: ReusableButton(
                    title: "Get membership for discounts",
                    onTap: () {
                      showSubscriptionPopup();
                    },
                  ),
                ),
              ));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void dialougeBox(String format, String? results) {
    if (!isDialogOpen) {
      isDialogOpen = true;
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.warning,
        body: Column(
          children: [
            Text("Qr Format $format "),
            Text("Congratulations $results "),
          ],
        ),
        btnOkOnPress: () {
          isDialogOpen = false;
        },
      ).show();
    }
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      // Check if it's a new month, reset the scan counter
      DateTime currentTimestamp = DateTime.now();
      if (lastScanTimestamp == null ||
          currentTimestamp.month != lastScanTimestamp!.month ||
          currentTimestamp.year != lastScanTimestamp!.year) {
        scanCounter = 0;
      }

      // Check if the user has scanned the QR code more than 3 times in the current month
      if (scanCounter < 3) {
        dialougeBox(describeEnum(scanData.format), scanData.code);

        // Save scanned data to Firestore
        try {
          await _firestore.collection('scannerdata').add({
            'format': describeEnum(scanData.format),
            'code': scanData.code,
            'timestamp': FieldValue.serverTimestamp(),
            'Name': result.toString(),
            "Discount": "",
          });

          // Increment the scan counter
          scanCounter++;

          // Update the last scan timestamp
          lastScanTimestamp = currentTimestamp;

          // Dispose the controller after the third scan
          if (scanCounter == 3) {
            controller.dispose();
          }
        } catch (e) {
          print('Error saving data to Firestore: $e');
        }
      } else {
        // Inform the user that they have reached the maximum scans for the month
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have reached the maximum scans for the month'),
          ),
        );
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    debugPrint('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No permission to access the camera'),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    "After getting a subscription, You can scan the QR code for discounts three times in a month.",
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
                          "Get Discounts Now",
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
        });
  }

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
                          Text("Payment Successful"),
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

  var SECRET_KEY =
      'sk_test_51MRaTJF6Z1rhh5U4coAffyEf0hQrV820sQzwuAo7xBKpvGw0mBaz6pNCBtXrZoYTJZxH9uIZCxK7rEAKUKK3VZPA00pGIqUKA1';
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
          .where('email', isEqualTo: widget.email.toString())
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
}
