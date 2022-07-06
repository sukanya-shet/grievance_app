import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/model/user.dart';
import 'package:grievance_app/providers/user_provider.dart';
import 'package:grievance_app/screens/comment_card.dart';
import 'package:grievance_app/services/firestore_methods.dart';
import 'package:grievance_app/utils/colors.dart';
import 'package:provider/provider.dart';

class CommentSection extends StatefulWidget {
  final snap;
  const CommentSection({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  TextEditingController _commentController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String name = "";
  String profileImage = "";

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  void getUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    setState(() {
      name = (snapshot.data() as Map<String, dynamic>)['name'];
      profileImage = (snapshot.data() as Map<String, dynamic>)['profileImage'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: mobileThemeColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('grievances')
            .doc(widget.snap['grievanceId'])
            .collection("comments")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                  snap: (snapshot.data! as dynamic).docs[index].data()));
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profileImage),
              radius: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _commentController,
                  autocorrect: true,
                  decoration: InputDecoration(
                      hintText: "Comment...", border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
                onTap: (() async {
                  await FireStoreMethods().postComment(
                      widget.snap['grievanceId'],
                      _auth.currentUser!.uid,
                      name,
                      _commentController.text,
                      profileImage);
                  setState(() {
                    _commentController.text = "";
                  });
                }),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                )),
          ],
        ),
      )),
    );
  }
}
