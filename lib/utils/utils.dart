import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  final image = await _picker.pickImage(source: source);
  if (image == null) {
    return;
  } else {
    return await image.readAsBytes();
  }
}
