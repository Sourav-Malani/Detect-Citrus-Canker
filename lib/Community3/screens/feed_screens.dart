import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigate back to the home screen when the back button is pressed
          Navigator.pushReplacementNamed(context, '/mobileScreenLayout');
          return false; // Prevent default back button behavior
        },
        child: Scaffold(
          appBar: AppBar(title: Text("Community"), backgroundColor: Colors.green,),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("post")
                .orderBy("datePublished", descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      PostCard(snap: snapshot.data!.docs[index].data()));
            },
          ),
        ));
  }
}
