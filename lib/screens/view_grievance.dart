import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grievance_app/screens/filter_screen.dart';
import 'package:grievance_app/screens/grievance_card.dart';
import 'package:grievance_app/screens/notifications_screen.dart';
import 'package:grievance_app/utils/colors.dart';

class ViewGrievance extends StatefulWidget {
  const ViewGrievance({Key? key}) : super(key: key);

  @override
  State<ViewGrievance> createState() => _ViewGrievanceState();
}

class _ViewGrievanceState extends State<ViewGrievance> {
  @override
  String searchKey = "";
  bool isClicked = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("View Grievances"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isClicked = !isClicked;
                    if (isClicked) {
                      searchKey = 'Road query';
                      print("done deal");
                    } else {
                      searchKey = "";
                    }
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FilterScreen()));
                },
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
                icon: Icon(Icons.notifications_active))
          ],
          backgroundColor: mobileThemeColor),
      body: StreamBuilder(
          stream: searchKey == ""
              ? FirebaseFirestore.instance
                  .collection('grievances')
                  .orderBy('datePosted', descending: true)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('grievances')
                  .where("category", isEqualTo: searchKey)
                  .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                child: GrievanceCard(snap: snapshot.data!.docs[index]),
              ),
            );
          }),
    );
  }
}
