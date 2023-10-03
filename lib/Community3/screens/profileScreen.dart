import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/resources/auth_methods.dart';
import 'package:canker_detect/Community3/resources/firestore_method.dart';
import 'package:canker_detect/Community3/screens/login_screen.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:canker_detect/utils/utils.dart';
import 'package:canker_detect/Community3/widgets/follow_button.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userSnap =
      await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
      setState(() {
        userData = userSnap.data() ?? {};
      });

      final postSnap =
      await FirebaseFirestore.instance.collection("post").where('uid', isEqualTo: widget.uid).get();
      setState(() {
        postLen = postSnap.docs.length;
      });

      setState(() {
        followers = userData["followers"] != null ? userData["followers"].length : 0;
      });

      setState(() {
        following = userData["following"] != null ? userData["following"].length : 0;
      });

      setState(() {
        isfollowing = userData["followers"] != null && userData["followers"].contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        userData["photourl"] = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(userData["username"] ?? "Username")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey,
                    backgroundImage: userData["photourl"] != null
                        ? FileImage(File(userData["photourl"])) as ImageProvider<Object>?
                        : userData["photourl"] != null
                        ? NetworkImage(userData["photourl"]) as ImageProvider<Object>?
                        : AssetImage("assets/images/default_profile_picture.jpeg") as ImageProvider<Object>?,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatColumn(postLen, "Posts"),
                          buildStatColumn(followers, "Followers"),
                          buildStatColumn(following, "Following"),
                        ],
                      ),
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? FollowButton(
                        backgroundColor: mobileBackgroundColor,
                        borderColor: Colors.grey,
                        text: "Sign Out",
                        textColor: primaryColor,
                        function: () async {
                          await AuthMethods().signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen()));
                        },
                      )
                          : isfollowing
                          ? FollowButton(
                        backgroundColor: Colors.white,
                        borderColor: Colors.grey,
                        text: "Unfollow",
                        textColor: Colors.black,
                        function: () async {
                          await FirestoreMethod().followUser(
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.uid!);
                          setState(() {
                            isfollowing = false;
                            followers--;
                          });
                        },
                      )
                          : FollowButton(
                        backgroundColor: Colors.blue,
                        borderColor: Colors.grey,
                        text: "Follow",
                        textColor: primaryColor,
                        function: () async {
                          await FirestoreMethod().followUser(
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.uid!);
                          setState(() {
                            isfollowing = true;
                            followers++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 15, left: 5),
            child: Text(
              userData["username"] ?? "Username",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 2,left: 5),
            child: Text(
              userData["email"] ?? "email@gmail.com",
            ),
          ),
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection("post").where("uid", isEqualTo: widget.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final data = snapshot.data as QuerySnapshot;

              if (data.docs.isEmpty) {
                return const Center(
                  child: Text("No posts available."),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  childAspectRatio: 1,
                  mainAxisSpacing: 1.5,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                  return Container(
                    child: Image(
                      image: NetworkImage(snap["postUrl"]),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
