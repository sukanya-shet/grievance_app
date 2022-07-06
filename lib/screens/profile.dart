// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/model/user.dart';
import 'package:grievance_app/screens/edit_profile_screen.dart';
import 'package:grievance_app/screens/issue_card.dart';
import 'package:grievance_app/screens/your_grievances.dart';
import 'package:grievance_app/services/auth.dart';
import 'package:grievance_app/utils/colors.dart';
import 'package:grievance_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference grievance =
      FirebaseFirestore.instance.collection('grievances');
  String name = "";
  String email = "";
  String profilePic =
      "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg";
  Uint8List? profileImage;
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
      email = (snapshot.data() as Map<String, dynamic>)['email'];
      profilePic = (snapshot.data() as Map<String, dynamic>)['profileImage'];
    });
  }

  Widget imageModal() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: <Widget>[
        const Text(
          "Choose an image",
          style: TextStyle(fontSize: 20.0),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton.icon(
              onPressed: () async {
                Uint8List image = await pickImage(ImageSource.camera);
                setState(() {
                  profileImage = image;
                });
              },
              label: Text("Camera"),
              icon: Icon(Icons.camera),
            ),
            TextButton.icon(
              onPressed: () async {
                Uint8List image = await pickImage(ImageSource.gallery);
                setState(() {
                  profileImage = image;
                });
              },
              label: Text("Gallery"),
              icon: Icon(Icons.image),
            ),
          ],
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: mobileThemeColor2,
          actions: [
            TextButton(
                onPressed: () {
                  context.read<AuthService>().signOut();
                },
                child: Text(
                  "Log out",
                  style: TextStyle(color: Colors.white60),
                ))
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(children: [
                    profileImage != null
                        ? CircleAvatar(
                            radius: 45,
                            backgroundImage: MemoryImage(profileImage!),
                          )
                        : CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(profilePic),
                          ),
                    Positioned(
                        child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                            ),
                            onPressed: () => showModalBottomSheet(
                                context: this.context,
                                builder: (builder) => imageModal())),
                        bottom: -5,
                        left: 50)
                  ]),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name),
                        Text(
                          email,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()));
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(),
              width: double.infinity,
              child: Text(
                "Your Grievances",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: mobileThemeColor),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('grievances')
                    .where('uid', isEqualTo: _auth.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  //print((snapshot.data as dynamic).docs[0]['description']);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => myGrievance(
                          snapshot.data!.docs[index]['category'],
                          snapshot.data!.docs[index]['description'],
                          snapshot.data!.docs[index]['image'],
                          snapshot.data!.docs[index]['address'],
                          snapshot.data!.docs[index]['status']));
                },
              ),
            ),
          ],
        ));
  }
}
