// Import necessary packages and libraries
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tfnd_app/const.dart';
import 'package:tfnd_app/models/AddEventModel.dart';
import 'package:tfnd_app/models/AddPostModel.dart';
import 'package:tfnd_app/models/AddUserModel.dart';
import 'package:http/http.dart' as http;

import 'package:tfnd_app/screens/comment.dart';

// Now TestMe from comment.dart will be used, and TestMe from test.dart will be hidden

import 'package:tfnd_app/themes/color.dart';
import 'package:tfnd_app/widgets/reusable_text.dart';
import 'package:tfnd_app/widgets/reusable_textformfield.dart';

// Define a stateful widget for event details
class eventsDetail extends StatefulWidget {
  final AddEventModel event; // Event data
  String UserEmail;

  // User's email

  // Constructor for eventsDetail widget
  eventsDetail({super.key, required this.event, required this.UserEmail});

  @override
  State<eventsDetail> createState() => _eventsDetailState();
}

// State class for eventsDetail widget
class _eventsDetailState extends State<eventsDetail> {
  List<AddPostModel> allposts = []; // List to store posts related to the event
  int likeCount = 9; // Initial like count

  bool isliked = false;

  int commentCount = 0;
  void handleCommentCountUpdate(int? count) async {
    if (count != null) {
      setState(() {
        commentCount = count;
      });

      // You can add any additional logic here based on the updated comment count
      print("Comment count updated to: $count");
    } else {
      // Handle the case where count is null
      print("Error: Comment count is null");
    }
  }

  getPosts() async {
    try {
      allposts.clear();
      setState(() {});
      FirebaseFirestore.instance
          .collection(StaticInfo.posts)
          .snapshots()
          .listen((event) {
        allposts.clear();
        setState(() {});
        for (int i = 0; i < event.docs.length; i++) {
          AddPostModel dataModel = AddPostModel.fromJson(event.docs[i].data());
          allposts.add(dataModel);

          print("all posts == ${allposts.length}");
        }

        setState(() {});
      });
      setState(() {});
    } catch (e) {}
  }

  // Map to track liked status of posts
  Map<String, bool> postLikedStatus = {};

  // Controller for the post description text field
  TextEditingController descriptionController = TextEditingController();

  // Function to send posts to Firestore
  SendPosts() async {
    isLoading = true;
    setState(() {});
    int id = DateTime.now().millisecondsSinceEpoch;
    AddPostModel dataModel = AddPostModel(
      description: descriptionController.text,
      image: userData!.image.toString(),
      name: userData!.name.toString(),
      date: DateTime.now().toString(),
      uid: id,
      likeCount: 0, // Initialize likeCount to 0
      likedBy: [], commentCount: 0, commentList: [],
      // Initialize likedBy as an empty list
    );
    try {
      await FirebaseFirestore.instance
          .collection(StaticInfo.posts)
          .doc('$id')
          .set(dataModel.toJson());
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Post Created Successfully');
    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Some Error Occurred');
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Initialize state
  @override
  void initState() {
    handleCommentCountUpdate(commentCount);
    getPosts();
    super.initState();
    initializeLikedStatus();
    postLikedStatus[widget.event.uid.toString()] = false;
    getUserData(widget.UserEmail);
    print(" Email is--${widget.UserEmail}");
    print(" event is--${widget.event.uid}");
  }

  void initializeLikedStatus() {
    for (var post in allposts) {
      postLikedStatus[post.uid.toString()] = false;
    }
  }

  final TextEditingController _cardController = TextEditingController();

  Map<String, dynamic>? paymentIntent;
  var SECRET_KEY =
      'sk_test_51MRaTJF6Z1rhh5U4coAffyEf0hQrV820sQzwuAo7xBKpvGw0mBaz6pNCBtXrZoYTJZxH9uIZCxK7rEAKUKK3VZPA00pGIqUKA1';

  AddUserModel? userData;
  bool isLiked = false;

  // Function to fetch user data from Firestore based on email
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
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  // Function to save payment details in Firestore
  savePaymentDetails() async {
    try {
      print("user data =${userData}");
      if (userData != null) {
        await FirebaseFirestore.instance.collection('payments').add({
          'userName': userData!.name.toString(),
          'amountPaid': widget.event.price,
          'eventDetails': {
            'eventName': widget.event.name,
            'eventDate': widget.event.date,
          },
          'timestamp': FieldValue.serverTimestamp(),
        });
        updateUserProfile();

        const SnackBar(
          padding: EdgeInsets.all(10),
          backgroundColor: AppColor.textColor,
          content: Text(
            'Booked Successfully!',
            style: TextStyle(color: AppColor.pinktextColor),
          ),
          duration: Duration(seconds: 2),
        );

        print("user data =${userData}");
        await FirebaseFirestore.instance
            .collection('RegisterUsers')
            .doc(userData!.email)
            .update({
          'bookedEvents': FieldValue.arrayUnion([widget.event.name])
        });
      }
    } catch (error) {
      print('Error saving payment details: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('Posts');
  Future<int> getCommentCount(String postId) async {
    try {
      var querySnapshot =
          await postsCollection.doc(postId).collection('comments').get();

      return querySnapshot.size;
    } catch (e) {
      print("Error fetching comment count: $e");
      return 0;
    }
  }

  // Function to initiate the payment process
  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('${widget.event.price}', 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'mubeen'))
          .then((value) {});

      displayPaymentSheet();
      savePaymentDetails();
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
                          Text("   Payment Successful"),
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

  Map<String, int> commentCounts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: AppColor.hintColor, // Change this color to the desired one
          ),
          centerTitle: true,
          title: const ReusableText(
            title: "Event Details",
            color: AppColor.pinktextColor,
            size: 20,
            weight: FontWeight.w500,
          ),
        ),
        // Floating action button for adding posts
        floatingActionButton: Form(
          key: _formKey,
          child: FloatingActionButton(
            onPressed: () {
              // Show a bottom sheet for adding posts
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: 0.7,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 100),
                              child: Divider(
                                thickness: 4,
                                color: AppColor.backgroundColor,
                              ),
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            const ReusableText(
                              title: 'Add Post',
                              color: AppColor.darkTextColor,
                              size: 17,
                              weight: FontWeight.bold,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            // Text form field for post description
                            ReusableTextForm(
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Please Add Post";
                                } else {
                                  return null;
                                }
                              },
                              controller: descriptionController,
                              hintText: "Type Here",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Button to submit the post
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      SendPosts();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: AppColor.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                      child: ReusableText(
                                        title: "Post",
                                        color: AppColor.whiteColor,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Icon(
              Icons.add,
              color: AppColor.whiteColor,
            ), // Add icon inside the button
            backgroundColor: AppColor.primaryColor, // Customize button color
          ),
        ),
        // Main body of the screen
        body: SafeArea(
          child: Column(
            children: [
              // Displaying event image
              widget.event.image == null
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: NetworkImage(
                                  "https://d2x3xhvgiqkx42.cloudfront.net/12345678-1234-1234-1234-1234567890ab/651c25b0-2d60-43c8-addf-1df2fd575568/2021/08/16/455d8bde-5940-4005-a79a-56005926c158/65b4998a-5202-4a77-af1e-c646f5fc36e1.png"),
                              fit: BoxFit.contain)),
                    )
                  : Container(
                      height: 190,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  NetworkImage(widget.event.image.toString()),
                              fit: BoxFit.fill)),
                    ),
              // Displaying event details
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Displaying event date and location
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableText(
                                title: '${widget.event.date}',
                                color: AppColor.blackColor,
                                weight: FontWeight.bold,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ReusableText(
                                title: '${widget.event.Location}',
                                color: AppColor.textColor,
                                weight: FontWeight.bold,
                                size: 11,
                              ),
                            ],
                          ),
                          // Displaying event price
                          ReusableText(
                            title: "\$${widget.event.price}",
                            color: AppColor.pinktextColor,
                            weight: FontWeight.bold,
                            size: 15,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      // Displaying event name and description
                      ReusableText(
                        title: '${widget.event.name}',
                        size: 17,
                        color: AppColor.darkTextColor,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ReusableText(
                        title: '${widget.event.discription}',
                        size: 13,
                        color: AppColor.textColor,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          showBookingDialog();
                        },
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                            color: AppColor.pinktextColor,
                            borderRadius: BorderRadius.circular(10),
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
                              "Book this Event",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      const Center(
                        child: ReusableText(
                          title: "Posts",
                          color: AppColor.blackColor,
                          weight: FontWeight.bold,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Displaying posts related to the event
              Expanded(
                child: ListView.builder(
                  itemCount: allposts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        ListTile(
                          title: ReusableText(
                            title: "${allposts[index].name}",
                            color: AppColor.darkTextColor,
                            weight: FontWeight.bold,
                            size: 14,
                          ),
                          subtitle: ReusableText(
                            title: allposts[index].date,
                            color: AppColor.hintColor,
                            size: 11,
                          ),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(allposts[index].image.toString()),
                          ),
                        ),
                        // Displaying post description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ReusableText(
                                  title: allposts[index].description,
                                  size: 13.5,
                                  color: AppColor.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Displaying like and comment counts
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          bool liked = postLikedStatus[
                                                  allposts[index]
                                                      .uid
                                                      .toString()] ??
                                              false;

                                          if (allposts[index]
                                              .likedBy
                                              .contains(userData!.email)) {
                                            // User has already liked, so remove the like
                                            allposts[index].likeCount--;
                                            allposts[index]
                                                .likedBy
                                                .remove(userData!.email);
                                          } else {
                                            // User hasn't liked, so add the like
                                            allposts[index].likeCount++;
                                            allposts[index].likedBy.add(
                                                userData!.email.toString());
                                          }

                                          // Save the updated like count and likedBy to Firestore for the specific post
                                          await FirebaseFirestore.instance
                                              .collection(StaticInfo.posts)
                                              .doc(allposts[index]
                                                  .uid
                                                  .toString())
                                              .update({
                                            'likeCount':
                                                allposts[index].likeCount,
                                            'likedBy': allposts[index].likedBy,
                                          });

                                          postLikedStatus[allposts[index]
                                              .uid
                                              .toString()] = !liked;
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              postLikedStatus[allposts[index]
                                                          .uid
                                                          .toString()] ??
                                                      false
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_outlined,
                                              color: postLikedStatus[
                                                          allposts[index]
                                                              .uid
                                                              .toString()] ??
                                                      false
                                                  ? AppColor.pinktextColor
                                                  // Change the color to red when liked
                                                  : AppColor.hintColor,
                                              size: 25,
                                            ),
                                            const SizedBox(width: 5),
                                            ReusableText(
                                              size: 12,
                                              title: allposts[index]
                                                  .likeCount
                                                  .toString(),
                                              color: AppColor.hintColor,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TestMe(
                                                  postId: allposts[index]
                                                      .uid
                                                      .toString(),
                                                  name: allposts[index]
                                                      .name
                                                      .toString(),
                                                  date: allposts[index]
                                                      .date
                                                      .toString(),
                                                  pic: allposts[index]
                                                      .image
                                                      .toString(),
                                                  curreentname:
                                                      userData!.name.toString(),
                                                  curreentpic: userData!.image
                                                      .toString(),
                                                  updateCommentCount:
                                                      handleCommentCountUpdate,
                                                ),
                                              ),
                                            );

                                            // Show a dialog box to get the comment
                                          },
                                          child: const Row(children: [
                                            Icon(
                                              Icons.comment_outlined,
                                              color: AppColor.primaryColor,
                                              size: 20,
                                            ),
                                            SizedBox(width: 5),
                                            ReusableText(
                                              size: 12,
                                              title: "Comments",
                                              color: AppColor.primaryColor,
                                              weight: FontWeight.bold,
                                            )
                                          ] // You might want to add a loading indicator or some other widget here

                                              ))
                                    ],
                                  ),
                                ]))
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }

  // Function to show the booking dialog
  void showBookingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'Event Booking',
            style: TextStyle(color: AppColor.primaryColor),
          )),
          content: Container(
            height: 120,
            child: Column(children: [
              const ReusableText(
                title: "Bookings",
                color: AppColor.blackColor,
                weight: FontWeight.bold,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Displaying total slots
                    Column(
                      children: [
                        const ReusableText(
                          title: "Total Slots",
                          color: AppColor.textColor,
                          weight: FontWeight.bold,
                          size: 12,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ReusableText(
                          title: '${widget.event.slot}',
                          color: AppColor.primaryColor,
                          weight: FontWeight.bold,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Displaying remaining slots
                    Column(
                      children: [
                        const ReusableText(
                          title: "Remaining Slots",
                          color: AppColor.textColor,
                          weight: FontWeight.bold,
                          size: 14,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ReusableText(
                          title: widget.event.remaining.toString(),
                          color: AppColor.darkTextColor,
                          weight: FontWeight.bold,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                await makePayment();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Payment',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColor.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to update the user profile after successful booking
  Future<void> updateUserProfile() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('adminevents')
          .where('uid', isEqualTo: widget.event.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        await doc.reference.update({
          'date': widget.event.date,
          'uid': widget.event.uid,
          'discription': widget.event.discription,
          'address': widget.event.date,
          'image': widget.event.image,
          'location': widget.event.Location,
          'name': widget.event.name,
          'price': widget.event.price,
          'slot': widget.event.slot,
          'remaining': (widget.event.remaining != null)
              ? (int.parse(widget.event.remaining.toString()) - 1).toString()
              : null,
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
        isLoading = false;
      });
    }
  }

// Function to show a dialog for posting and viewing comments
}
