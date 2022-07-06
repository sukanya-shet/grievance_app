import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final int contact;
  final int pincode;
  final String profileImage;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.contact,
      required this.pincode,
      required this.profileImage});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "contact": contact,
        "pincode": pincode,
        "profileImage": profileImage
      };

  static UserModel fromSnap(DocumentSnapshot doc) {
    dynamic data = doc.data;

    return UserModel(
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        contact: data['contact'],
        pincode: data['pincode'],
        profileImage: data['profileImage']);
  }
}
