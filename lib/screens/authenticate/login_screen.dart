// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/screens/authenticate/register_screen.dart';
import 'package:grievance_app/services/auth.dart';
import 'package:grievance_app/utils/utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void signInUser() async {
    setState(() {
      isLoading = true;
    });
    String output = await AuthService().signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    setState(() {
      isLoading = false;
    });

    if (output != "success") {
      showSnackBar(context, output);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 77, 122)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          //text field for email
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                label: Text("Email"),
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.blue[900],
                )),
          ),
          SizedBox(
            height: 4,
          ),
          //text field for password
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
                label: Text("Password"),
                prefixIcon: Icon(Icons.lock, color: Colors.blue[900])),
          ),
          SizedBox(
            height: 10,
          ),
          //sign in button
          Container(
            width: double.infinity,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                    onPressed: signInUser,
                    child: Text("Sign in")),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: "Not an existing user? ",
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ));
                      })
              ],
            ),
          )
        ]),
      ),
    ));
  }
}
