import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/model/user.dart';
import 'package:grievance_app/screens/image_storage.dart';
import 'package:grievance_app/utils/colors.dart';
import 'package:grievance_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name = "";
  String contact = "";
  String pin = "";
  final TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();

  UserModel? user;
  String tempProfileImage =
      "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg";
  bool isLoading = false;
  Uint8List? profileImage;

  void getUserDetails() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    tempProfileImage =
        (doc.data() as Map<String, dynamic>)['profileImage'].toString();
    _nameController.text = (doc.data() as Map<String, dynamic>)['name'];
    _contactController.text =
        (doc.data() as Map<String, dynamic>)['contact'].toString();
    _pincodeController.text =
        (doc.data() as Map<String, dynamic>)['pincode'].toString();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  void updateProfile() async {
    setState(() {
      isLoading = true;
    });
    String imageUrl = await ImageStorage().uploadProfileImage(profileImage);
    print('pofile updating');
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid);
    docUser.update({
      'name': _nameController.text,
      'contact': _contactController.text,
      'pincode': _pincodeController.text,
      'profileImage': imageUrl
    });
    setState(() {
      isLoading = false;
    });

    showSnackBar(context, "Profile updated!");
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
        title: Text("Edit Profile"),
        backgroundColor: mobileThemeColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 15),
                Stack(children: [
                  Center(
                    child: profileImage != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(profileImage!),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(tempProfileImage),
                          ),
                  ),
                  Positioned(
                      child: IconButton(
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                          onPressed: () => showModalBottomSheet(
                              context: this.context,
                              builder: (builder) => imageModal())),
                      bottom: -5,
                      right: 100)
                ]),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Contact',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _pincodeController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      updateProfile();
                    },
                    child: Text("Update"),
                    style: ElevatedButton.styleFrom(
                        primary: mobileThemeColor,
                        textStyle: TextStyle(fontSize: 15)),
                  ),
                )
              ],
            ),
    );
  }
}
