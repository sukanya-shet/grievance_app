import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/providers/user_provider.dart';
import 'package:grievance_app/screens/add_grievance.dart';
import 'package:grievance_app/screens/information.dart';
import 'package:grievance_app/screens/map_screen.dart';
import 'package:grievance_app/screens/profile.dart';
import 'package:grievance_app/screens/view_grievance.dart';

import 'package:grievance_app/utils/colors.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final screens = [
    ViewGrievance(),
    MapScreen(),
    GrievanceForm(),
    InfoScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    super.initState();
    addData();
  }

  //UserModel user = Provider.of<UserProvider>(context).getUser;

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: mobileThemeColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map_outlined,
              ),
              label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_rounded,
                size: 40,
              ),
              label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.info_outline_rounded,
              ),
              label: 'Info'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile')
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
