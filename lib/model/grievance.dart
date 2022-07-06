import 'package:cloud_firestore/cloud_firestore.dart';

class GrievanceModel {
  final String uid;
  final String name;
  final String grievanceId;
  final String category;
  final String description;
  final DateTime datePosted;
  final String image;
  final List votes;
  final String status;
  final String address;
  final GeoPoint location;
  final String profileImage;

  GrievanceModel(
      {required this.uid,
      required this.name,
      required this.grievanceId,
      required this.category,
      required this.description,
      required this.datePosted,
      required this.image,
      required this.votes,
      required this.status,
      required this.address,
      required this.location,
      required this.profileImage});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "grievanceId": grievanceId,
        "category": category,
        "description": description,
        "datePosted": datePosted,
        "image": image,
        "votes": votes,
        "status": status,
        "address": address,
        "location": location,
        "profileImage": profileImage
      };

  static GrievanceModel fromSnap(DocumentSnapshot doc) {
    dynamic data = doc.data;

    return GrievanceModel(
        uid: data['uid'],
        name: data['name'],
        grievanceId: data["grievanceId"],
        category: data["category"],
        description: data["description"],
        datePosted: data["datePosted"],
        image: data['image'],
        votes: data['votes'],
        status: data['status'],
        address: data['address'],
        location: data['location'],
        profileImage: data['profileImage']);
  }
}
