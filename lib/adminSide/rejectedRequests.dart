import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/adminSide/rejectedBusinessDetails.dart';

import 'package:tfnd_app/screens/userSide/oneToOnechat.dart';
import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class rejectedRequests extends StatefulWidget {
  @override
  State<rejectedRequests> createState() => _rejectedRequestsState();
}

class _rejectedRequestsState extends State<rejectedRequests> {
  late Future<List<Map<String, dynamic>>> rejectrequest;

  void initState() {
    super.initState();
    rejectrequest = fetchApprovedRequests();
  }

  Future<List<Map<String, dynamic>>> fetchApprovedRequests() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('requests')
        .where('status', isEqualTo: 'rejected')
        .get();

    List<Map<String, dynamic>> rejectRequests = querySnapshot.docs
        .map((doc) => {
              'userName': doc['userName'] as String,
              'status': doc['status'] as String,
              'imageUrl': doc['imageUrl'] as String,

              'email': doc['email'] as String,
              'location': doc['location'] as String,
              'phone': doc['phone'] as String,

              // Replace with your actual field name
              // Replace with your actual field name
            })
        .toList();

    return rejectRequests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: rejectrequest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> items = snapshot.data ?? [];

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    ListTile(
                      trailing: const ReusableText(
                        title: '',
                        color: AppColor.hintColor,
                      ),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(items[index]['imageUrl'].toString()),
                        radius: 35,
                      ),
                      title: ReusableText(
                        title: items[index]['userName'] ?? '',
                        color: AppColor.darkTextColor,
                        weight: FontWeight.w600,
                        size: 13.5,
                      ),
                      subtitle: ReusableText(
                        title: items[index]['status'] ?? '',
                        color: AppColor.textColor,
                        weight: FontWeight.w600,
                        size: 11,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                rejectedBusinessDetails(
                              userName: items[index]['userName'],
                              status: items[index]['status'],
                              imageUrl: items[index]['imageUrl'],
                              email: items[index]['email'],
                              location: items[index]['location'],
                              phone: items[index]['phone'],
                              // Add other parameters as needed
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
