import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:tfnd_app/themes/color.dart';

class TestMe extends StatefulWidget {
  final String postId;
  final String name;
  final String date;
  final String pic;
  final String curreentname;
  final String curreentpic;
  final Function(int) updateCommentCount; // Add this line

  TestMe(
      {required this.postId,
      required this.name,
      required this.date,
      required this.pic,
      required this.curreentname,
      required this.updateCommentCount,
      required this.curreentpic});

  @override
  _TestMeState createState() => _TestMeState();
}

class _TestMeState extends State<TestMe> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('Posts');

  Widget commentChild(List data, String postId) {
    return FutureBuilder(
      future: postsCollection.doc(postId).collection('comments').get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: AppColor.pinktextColor,
                  ),
                  height: 50.0,
                  width: 50.0,
                ),
              ),
            ],
          );
        }

        List<DocumentSnapshot> commentDocs = snapshot.data!.docs;

        return ListView(
          children: [
            for (var i = 0; i < data.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () async {
                      // Display the image in large form.
                      print("Comment Clicked");
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: CommentBox.commentImageParser(
                            imageURLorPath: data[i]['pic']),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data[i]['message']),
                  trailing:
                      Text(widget.date, style: const TextStyle(fontSize: 10)),
                ),
              ),
            for (var doc in commentDocs)
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () async {
                      // Display the image in large form.
                      print("Comment Clicked");
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: CommentBox.commentImageParser(
                            imageURLorPath: doc['pic']),
                      ),
                    ),
                  ),
                  title: Text(
                    doc['name'],
                    style: const TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(doc['message']),
                  trailing: Container(
                    width: 80,
                    child: Text(
                      doc['date'],
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<int> getCommentCount() async {
    var querySnapshot =
        await postsCollection.doc(widget.postId).collection('comments').get();

    return querySnapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: FutureBuilder<int>(
          future: getCommentCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                "Comment:",
                style: TextStyle(color: Colors.white),
              );
            } else {
              widget.updateCommentCount(snapshot.data ?? 0);
              return Text(" ${snapshot.data} Comments",
                  style: const TextStyle(
                    color: Colors.white,
                  ));
            }
          },
        ),
        backgroundColor: AppColor.pinktextColor,
      ),
      body: Container(
        child: CommentBox(
          userImage: CommentBox.commentImageParser(
              imageURLorPath: widget.curreentpic.toString()),
          child: commentChild([], widget.postId),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          withBorder: false,
          sendButtonMethod: () async {
            if (formKey.currentState!.validate()) {
              var commentData = {
                'name': widget.curreentname.toString(),
                'pic': widget.curreentpic.toString(),
                'message': commentController.text,
                'date': widget.date.toString(),
              };

              // Save comment to Firestore
              await postsCollection
                  .doc(widget.postId)
                  .collection('comments')
                  .add(commentData);

              setState(() {
                // Reload comments from Firestore after adding a new comment
                // You might consider using a StreamBuilder for real-time updates
              });

              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: AppColor.pinktextColor,
          textColor: Colors.white,
          sendWidget:
              const Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
