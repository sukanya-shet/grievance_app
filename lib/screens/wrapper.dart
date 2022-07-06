import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/screens/home/home.dart';
import 'package:grievance_app/screens/authenticate/login_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User?>();

    if (firebaseuser != null) {
      return Home();
    }
    return LoginScreen();
  }
}
