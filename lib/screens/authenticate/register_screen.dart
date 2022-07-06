import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/screens/authenticate/login_screen.dart';
import 'package:grievance_app/services/auth.dart';
import 'package:grievance_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController contactController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController pincodeController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    contactController.dispose();
    nameController.dispose();
    pincodeController.dispose();

    super.dispose();
  }

  void signUpUser() async {
    //context.read<AuthService>()
    setState(() {
      isLoading = true;
    });

    String output = await AuthService().signUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        contact: int.parse(contactController.text.trim()),
        pincode: int.parse(pincodeController.text.trim()),
        name: nameController.text.trim());
    print(output);

    setState(() {
      isLoading = false;
    });

    if (output != 'success') {
      showSnackBar(context, output);
      print(output);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
      showSnackBar(context, "User successfully registered!");
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
              "Register",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 77, 122)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
                label: Text("Full Name"),
                prefixIcon: Icon(Icons.person, color: Colors.blue[900])),
          ),
          SizedBox(
            height: 4,
          ),
          TextField(
            controller: contactController,
            decoration: InputDecoration(
                label: Text("Contact Number"),
                prefixIcon: Icon(Icons.phone, color: Colors.blue[900])),
          ),
          SizedBox(
            height: 4,
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
          TextField(
            controller: pincodeController,
            maxLength: 6,
            decoration: InputDecoration(
                label: Text("Pincode"),
                prefixIcon: Icon(Icons.location_on, color: Colors.blue[900])),
          ),
          SizedBox(
            height: 10,
          ),
          //sign in button
          Container(
            width: double.infinity,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                    onPressed: signUpUser,
                    child: Text("Sign up")),
          ),
          const SizedBox(
            height: 4,
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: "Have an account? ",
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: "Sign In",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
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
