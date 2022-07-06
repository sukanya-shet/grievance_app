import 'package:flutter/cupertino.dart';
import 'package:grievance_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/services/auth.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel? user = await AuthService().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
