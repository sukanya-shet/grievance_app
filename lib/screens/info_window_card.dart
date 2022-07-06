import 'package:flutter/material.dart';
import 'package:grievance_app/screens/decription_card.dart';

Container infoWindowCard(String name, String address, String category,
    String description, String image, int votes, String profileImage) {
  return Container(
      height: 400,
      width: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset.zero),
          ],
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.fitWidth,
                    filterQuality: FilterQuality.high),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
          UserProfileCard(name, address, profileImage),
          DescriptionCard(category, description, votes)
        ],
      ));
}
