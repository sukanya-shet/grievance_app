import 'package:flutter/material.dart';
import 'package:grievance_app/screens/comments.dart';
import 'package:grievance_app/services/firestore_methods.dart';
import 'package:intl/intl.dart';

class GrievanceCard extends StatelessWidget {
  final snap;
  const GrievanceCard({Key? key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDetails(snap['name'], snap['address'], snap['profileImage']),
          Container(
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      snap['image'] ?? "https://i.redd.it/j2ink51mnxz51.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.comment),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    await FireStoreMethods().upvoteGrievance(
                        snap['grievanceId'], snap['uid'], snap['votes']);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_circle_up),
                          Text(snap['votes'].length.toString()),
                        ],
                      )),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(15.0)),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snap['category'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: snap['status'] == "Pending"
                              ? Colors.green[500]
                              : Colors.red,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Text(
                        snap['status'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(snap['description']),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentSection(
                            snap: snap,
                          )));
            },
            child: const Padding(
              padding: EdgeInsets.only(
                left: 8,
                top: 3,
              ),
              child: Text(
                "View comments",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8, top: 3, bottom: 4),
            child: Text(
              DateFormat.yMMMd().format(snap['datePosted'].toDate()),
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

Container UserDetails(String name, String address, String profileImage) {
  return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            child: ClipOval(
              child: Image.network(
                profileImage,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 24, 55, 81)),
              ),
              Text(
                address,
                style: TextStyle(color: Colors.grey),
              )
            ]),
          )
        ],
      ));
}
