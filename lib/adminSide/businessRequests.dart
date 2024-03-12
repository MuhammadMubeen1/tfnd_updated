import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tfnd_app/adminSide/aBusinessDetails.dart';
import 'package:tfnd_app/adminSide/businessRequestHistory.dart';

import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class businessRequests extends StatefulWidget {
  const businessRequests({super.key});

  @override
  State<businessRequests> createState() => _businessRequestsState();
}

class _businessRequestsState extends State<businessRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.hintColor,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const businessRequestHistory(
                    approvedData: {},
                    rejectedData: {},
                  ),
                ),
              );
            },
            child: Icon(
              Icons.history,
              color: AppColor.hintColor,
              size: 28,
            ),
          ),
        ),
        title: ReusableText(
          title: "Pending Requests",
          color: AppColor.pinktextColor,
          size: 20,
          weight: FontWeight.w500,
        ),
        actions: [
          Icon(
            Icons.search_outlined,
            size: 28,
            color: AppColor.hintColor,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('requests').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];

              // Check the status of the request
              String status = request['status'];

              // Include only requests with status 'pending'
              if (status == 'pending') {
                return ListTile(
                  trailing: const ReusableText(
                    title: "",
                    color: AppColor.hintColor,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(request['imageUrl']),
                    radius: 35,
                  ),
                  title: ReusableText(
                    title: "${request['userName']}",
                    color: AppColor.darkTextColor,
                    weight: FontWeight.w600,
                    size: 13.5,
                  ),
                  subtitle: ReusableText(
                    title: "$status",
                    color: AppColor.textColor,
                    weight: FontWeight.w600,
                    size: 11,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => aBusinessDetails(
                          requestData: request.data() as Map<String, dynamic>,
                        ),
                      ),
                    );
                  },
                );
              } else {
                // If status is not 'pending', return an empty container
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
