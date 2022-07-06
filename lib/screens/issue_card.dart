import 'package:flutter/material.dart';

Container myGrievance(String category, String description, String image,
    String address, String status) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.all(6),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 5,
          )
        ],
        borderRadius: BorderRadius.circular(8)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(image),
          radius: 30,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              width: 180,
              child: Text(
                address,
                style: TextStyle(color: Colors.grey),
                maxLines: 2,
              ),
            ),
            Text(description)
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: status == "Pending" ? Colors.green[500] : Colors.red,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Text(
                status,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
