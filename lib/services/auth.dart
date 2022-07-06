import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grievance_app/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //create user obj based on FirebaseUser
  /* UserModel? _userFromFirebaseUser(User user) {
   return user != null ? UserModel(uid: user.uid) : null;
  }*/
  Future<UserModel?> getUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    return UserModel.fromSnap(snapshot);
  }

//  AuthService(this._auth);
  Future signInAnonymous() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> signInWithEmail(
      {required String email, required String password}) async {
    String output = "success";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        User? user = result.user;
        return output;
      }
    } on FirebaseAuthException catch (e) {
      output = (e.toString());
    }
    return output;
  }

  Future<String> signUpWithEmail(
      {required String name,
      required int contact,
      required String email,
      required String password,
      required int pincode}) async {
    String output = " ";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User user = result.user!;
        String profileImage =
            "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg";

        UserModel userModel = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          contact: contact,
          pincode: pincode,
          profileImage: profileImage,
        );

        print(user.uid);
        //add user to database
        _firestore.collection('users').doc(user.uid).set(userModel.toJson());
        print("Success sign up");
      }
      return "success";
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        output = "Badly formatted email";
      } else if (error.code == 'weak-password') {
        output = "Password should contain atleast 6 characters";
      }
    }
    return output;
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
