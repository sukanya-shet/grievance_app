import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ImageStorage {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future uploadProfileImage(Uint8List? image) async {
    // storageRef.ref().child(collectionName).child(uploadFileName)
    /*UploadTask task = FirebaseStorage.instance.ref(destination).putFile(image!);
    final snapshot = await task.whenComplete(() {});
    final ImageUrl = await snapshot.ref.getDownloadURL();*/

    Reference ref =
        _storage.ref().child("profilePhotos").child(_auth.currentUser!.uid);
    await ref.putData(image!);
    String ImageUrl = await ref.getDownloadURL();
    print(ImageUrl);

    return ImageUrl;
  }
}
