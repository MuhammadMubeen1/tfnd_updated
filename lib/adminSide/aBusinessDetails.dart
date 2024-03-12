import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/adminSide/businessRequestHistory.dart';
import 'package:tfnd_app/adminSide/buttom_navigation.dart';

import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class aBusinessDetails extends StatefulWidget {
  final Map<String, dynamic> requestData;

  const aBusinessDetails({Key? key, required this.requestData})
      : super(key: key);

  @override
  State<aBusinessDetails> createState() => _aBusinessDetailsState();
}

class _aBusinessDetailsState extends State<aBusinessDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor.hintColor,
        ),
        centerTitle: true,
        title: ReusableText(
          title: "Business Details",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 25,
                  color: AppColor.hintColor,
                ),
                SizedBox(
                  width: 20,
                ),
                ReusableText(
                  title: widget.requestData['userName'] ?? '',
                  size: 15,
                  color: AppColor.darkTextColor,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 25,
                  color: AppColor.hintColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                ReusableText(
                  title: widget.requestData['phone'] ?? '',
                  size: 15,
                  color: AppColor.darkTextColor,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 25,
                  color: AppColor.hintColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                ReusableText(
                  title: widget.requestData['email'] ?? '',
                  size: 15,
                  color: AppColor.darkTextColor,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_city_outlined,
                  size: 25,
                  color: AppColor.hintColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ReusableText(
                    title: widget.requestData['location'] ?? '',
                    size: 15,
                    color: AppColor.darkTextColor,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Buttomnavigation(),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      // Accept button tapped
                      handleRequestStatus(
                          widget.requestData['requestId'], 'approved');
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Center(
                        child: ReusableText(
                          color: AppColor.whiteColor,
                          weight: FontWeight.bold,
                          title: "Approve",
                        ),
                      ),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Buttomnavigation(),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      // Reject button tapped
                      handleRequestStatus(
                          widget.requestData['requestId'], 'rejected');
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Center(
                        child: ReusableText(
                          color: Colors.red,
                          weight: FontWeight.bold,
                          title: "Reject",
                        ),
                      ),
                    ),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void handleRequestStatus(String requestId, String status) async {
    try {
      // Access the Firestore collection for requests
      CollectionReference requestsCollection =
          FirebaseFirestore.instance.collection('requests');

      // Update the status of the request
      await requestsCollection.doc(requestId).update({'status': status});

      // Display a success message or navigate to another screen
      print('Request $requestId $status successfully');

      // Retrieve the updated data from Firestore
      var updatedData = await requestsCollection.doc(requestId).get();

      // Navigate to the appropriate screen based on the status
      if (status == 'approved') {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => businessRequestHistory(
              approvedData: updatedData.data() as Map<String, dynamic>,
              rejectedData: {},
            ),
          ),
        );
      } else if (status == 'rejected') {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => businessRequestHistory(
              rejectedData: updatedData.data() as Map<String, dynamic>,
              approvedData: {},
            ),
          ),
        );
      } else {
        // Handle other statuses if needed
        // ...
      }
    } catch (error) {
      print('Error updating request status: $error');
      // Handle error as needed
    }
  }
}
