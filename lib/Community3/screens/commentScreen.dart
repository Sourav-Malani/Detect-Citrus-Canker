import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/resources/firestore_method.dart';
//import 'package:canker_detect/utils/colors.dart';
//import 'package:canker_detect/utils/utils.dart';
import 'package:provider/provider.dart';

import 'package:canker_detect/Community3/providers/user_providers.dart';
import 'package:canker_detect/Community3/resources/user.dart';
import 'package:canker_detect/Community3/widgets/comment_card.dart';

class CommentSection extends StatefulWidget {
  final snap;
  const CommentSection({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.grey,
        title: Text("Comments"),
      ),
      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("post")
            .doc(widget.snap["postId"])
            .collection("comments").orderBy("datePublished",descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index)=>CommentCard(
                  snap:(snapshot.data as dynamic).docs[index].data()
              ));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(children: [
            CircleAvatar(
                radius: 18, backgroundImage: NetworkImage(user.photoUrl)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      hintText: "Comment as ${user.username}",
                      border: InputBorder.none),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                String res = await FirestoreMethod().postComment(
                    widget.snap["postId"],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
                setState(() {
                  _commentController.text = "";
                });
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: const Text("Post",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent)),
              ),
            )
          ]),
        ),
      ),
    );
  }
}