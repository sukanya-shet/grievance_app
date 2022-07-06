import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grievance_app/model/grievance.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadGrievance(
      String uid,
      String name,
      String category,
      String description,
      String imageUrl,
      String address,
      GeoPoint location,
      String profileImage) async {
    String res = "error";
    try {
      String grievanceId = const Uuid().v1();
      GrievanceModel grievance = GrievanceModel(
          uid: uid,
          name: name,
          grievanceId: grievanceId,
          category: category,
          description: description,
          datePosted: DateTime.now(),
          image: imageUrl,
          votes: [],
          status: "Pending",
          address: address,
          location: location,
          profileImage: profileImage);

      _firestore
          .collection('grievances')
          .doc(grievanceId)
          .set(grievance.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> upvoteGrievance(
      String grievanceId, String uid, List votes) async {
    String res = "success";
    try {
      if (votes.contains(uid)) {
        _firestore.collection('grievances').doc(grievanceId).update({
          'votes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('grievances').doc(grievanceId).update({
          'votes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      res = err.toString();
      print(res);
    }
  }

  Future<void> postComment(String grievanceId, String uid, String name,
      String comment, String profileImage) async {
    try {
      final commentId = Uuid().v1();
      if (comment.isNotEmpty) {
        await _firestore
            .collection('grievances')
            .doc(grievanceId)
            .collection("comments")
            .doc(commentId)
            .set({
          'name': name,
          'comment': comment,
          'uid': uid,
          'datePublished': DateTime.now(),
          'profileImage': profileImage
        });
      } else {
        print("Comment is empty");
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
