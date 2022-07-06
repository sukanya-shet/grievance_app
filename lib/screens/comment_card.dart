import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['profileImage']),
          radius: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: widget.snap['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(text: " "),
                  TextSpan(
                      text: widget.snap['comment'],
                      style: TextStyle(color: Colors.black)),
                ]),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "03/06/2022",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
