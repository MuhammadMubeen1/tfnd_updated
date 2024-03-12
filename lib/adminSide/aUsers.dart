import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tfnd_app/screens/auth/signin.dart';

import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';

class aUsers extends StatefulWidget {
  const aUsers({Key? key}) : super(key: key);

  @override
  State<aUsers> createState() => _aUsersState();
}

class _aUsersState extends State<aUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColor.hintColor,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const ReusableText(
            title: "Registered Users",
            color: AppColor.pinktextColor,
            size: 20,
            weight: FontWeight.w500,
          ),
          actions: [
            // Icon(
            //   Icons.search_outlined,
            //   size: 28,
            //   color: AppColor.hintColor,
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            GestureDetector(
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
              child: Icon(
                Icons.logout_outlined,
                color: AppColor.hintColor,
                size: 30,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('RegisterUsers')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(); // or some loading indicator
              }

              var documents = snapshot.data?.docs;
              return ListView.builder(
                  itemCount: documents!.length,
                  itemBuilder: (context, index) {
                    var document = documents[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            document['name'],
                            style: const TextStyle(
                              color: AppColor.darkTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            document['email'],
                            style: const TextStyle(
                              color: AppColor.hintColor,
                              fontSize: 12,
                            ),
                          ),
                          // Add other widgets to display other fields as needed
                        ),
                        const Divider(
                          // Set the height of the divider
                          color: AppColor.hintColor,
                          thickness: 0.3, // Set the color of the divider
                        ),
                      ],
                    );
                  });
            }));
  }
}
