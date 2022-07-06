import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YourGrievances extends StatefulWidget {
  const YourGrievances({Key? key}) : super(key: key);

  @override
  State<YourGrievances> createState() => _YourGrievancesState();
}

class _YourGrievancesState extends State<YourGrievances> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Grievances")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('grievances')
            .where('uid', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //print((snapshot.data as dynamic).docs[0]['description']);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => ListTile(
              leading: Image(
                image: NetworkImage(snapshot.data!.docs[index]['image']),
                fit: BoxFit.cover,
              ),
              title: Text(snapshot.data!.docs[index]['category']),
              subtitle: Text("Malleshwaram"),
              trailing: Text("5 votes"),
            ),
          );
        },
      ),
    );
  }
}
