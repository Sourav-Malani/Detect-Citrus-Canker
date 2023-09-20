import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:canker_detect/Community3/providers/user_providers.dart';
import 'package:provider/provider.dart';

import '../resources/user.dart';

class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({Key? key, required this.snap}) : super(key: key);
  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(widget.snap['profilepic']),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: widget.snap['name'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: ' ${widget.snap['text']}',
                    style: TextStyle(color: Colors.black),
                  )
                ])),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.favorite,
            size: 16,
          ),
        )
      ]),
    );
  }
}
