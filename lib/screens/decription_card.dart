import 'package:flutter/material.dart';

Container DescriptionCard(String category, String description, int votes) {
  return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox.fromSize(
            size: Size(45, 45),
            child: ClipOval(
              child: Material(
                color: Color.fromARGB(255, 21, 76, 121),
                child: Column(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    Text(
                      votes.toString(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ));
}

Container UserProfileCard(String name, String address, String profileImage) {
  return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            child: ClipOval(
              child: Image.network(
                profileImage,
                width: 50,
                height: 50,
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
