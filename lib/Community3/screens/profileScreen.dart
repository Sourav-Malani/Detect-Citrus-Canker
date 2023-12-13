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

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';



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
  TextEditingController newUsernameController = TextEditingController();

  @override
  void initState() {
    print("Current User UD: ${FirebaseAuth.instance.currentUser!.uid}");
    super.initState();
    getData();
    newUsernameController.text = userData?["username"] ?? "";
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
      if (userSnap.exists) {
        setState(() {
          userData = userSnap.data() ?? {};
        });

        var postsSnapshot = await FirebaseFirestore.instance.collection("post").where("uid", isEqualTo: widget.uid).get();
        postLen = postsSnapshot.docs.length; // Update post count based on the user's posts
      } else {
        // Handle the case where userSnap doesn't exist
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateUsername(String newUsername) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(widget.uid).update({
        "username": newUsername,
      });

      setState(() {
        userData["username"] = newUsername;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username updated successfully."),
        ),
      );
    } catch (e) {
      showSnackBar("Error updating username: $e", context);
    }
  }

  Future<bool> checkUsernameAvailability(String newUsername) async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection("users").where("username", isEqualTo: newUsername).get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      showSnackBar("Error checking username availability: $e", context);
      return false;
    }
  }

  void showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          backgroundColor: Colors.white,
          content: TextField(
            controller: newUsernameController,
            decoration: InputDecoration(
              hintText: "Enter new username",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String newUsername = newUsernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  bool isUsernameAvailable = await checkUsernameAvailability(newUsername);

                  if (isUsernameAvailable) {
                    await updateUsername(newUsername);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Username is already taken."),
                      ),
                    );
                  }
                }
              },
              child: Text("Save"),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
              style: TextButton.styleFrom(
                primary: Colors.lightGreen,
              ),
            ),
          ],
        );
      },
    );
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
          child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigate back to the home screen when the back button is pressed
          Navigator.pushReplacementNamed(context, '/mobileScreenLayout');
          return false; // Prevent default back button behavior
        },

    child: isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/icon/icon.png',height:20,width:20),
        backgroundColor: Colors.green,
        title: Text(
          userData["username"] != null ? userData["username"] : "username",
          style: TextStyle(color: Theme.of(context).textTheme.headline6!.color),
        ),
        actions: [
          if (FirebaseAuth.instance.currentUser!.uid == widget.uid)
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).textTheme.headline6!.color,
              onPressed: () {
                showEditProfileDialog(context);
              },
            ),
          IconButton(
            icon: Icon(Icons.photo),
            color: Theme.of(context).textTheme.headline6!.color,
            onPressed: () {
              showChangeProfilePictureDialog(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.lightGreen,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                      userData["photourl"]),
                ),
              ),),
              Expanded(
                      flex: 1,
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
                            backgroundColor: Colors.lightGreen.shade400,
                            borderColor: Colors.lightGreen.shade400,
                            text: "Sign Out",
                            //textColor: Theme.of(context).textTheme.headline6!.color,
                            textColor: Theme.of(context).textTheme.headline6?.color ?? Colors.black,
                            function: () async {
                              await AuthMethods().signOut();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
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
                                widget.uid!,
                              );
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
                            textColor: Theme.of(context).primaryColor,
                            function: () async {
                              await FirestoreMethod().followUser(
                                FirebaseAuth.instance.currentUser!.uid,
                                widget.uid!,
                              );
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
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    userData["username"] != null ? userData["username"] : "username",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headline6!.color),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    userData["email"] != null ? userData["email"] : "email@gmail.com",
                    style: TextStyle(color: Theme.of(context).textTheme.headline6!.color),
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection("post").where("uid", isEqualTo: widget.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  void showChangeProfilePictureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Profile Picture"),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    File imageFile = File(pickedImage.path);
                    String fileName = "${widget.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
                    final Reference storageReference = FirebaseStorage.instance.ref().child('profile_images/$fileName');

                    await storageReference.putFile(imageFile);

                    final String downloadURL = await storageReference.getDownloadURL();

                    setState(() {
                      userData["photourl"] = downloadURL;
                    });

                    await FirebaseFirestore.instance.collection("users").doc(widget.uid).update({
                      "photourl": downloadURL,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Profile picture updated successfully."),
                      ),
                    );
                  }
                },
                child: Text("Choose from Gallery"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  final pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    // Same logic as above for uploading and updating
                  }
                },
                child: Text("Take a Photo"),
              ),
            ],
          ),
        );
      },
    );
  }
}

