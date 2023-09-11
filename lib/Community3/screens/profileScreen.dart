import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/resources/auth_methods.dart';
import 'package:canker_detect/Community3/resources/firestore_method.dart';
import 'package:canker_detect/Community3/screens/login_screen.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:canker_detect/utils/utils.dart';
import 'package:canker_detect/Community3/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;

  const ProfileScreen({Key? key,required this.uid}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;
  bool isLoading = false;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap = await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
      setState(() {
        userData = userSnap.data()!;
      });
      //get post link
      var postSnap = await FirebaseFirestore.instance.collection("post").where('uid', isEqualTo: widget.uid).get();
      setState(() {
        postLen = postSnap.docs.length;
      });
      setState(() {
        followers = userSnap.data()!["followers"].length;
      });
      setState(() {
        following = userSnap.data()!["following"].length;
      });
      setState(() {
        isfollowing = userSnap.data()!["followers"].contains(FirebaseAuth.instance.currentUser!.uid);
      });

    }catch(e){
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
            child: Text(label,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey))),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return
      isLoading?const Center(child: CircularProgressIndicator()):
      Scaffold(
        appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: Text(userData["username"]!=null?userData["username"]:"username")
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
                          radius: 48,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              userData["photourl"])),
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
                                buildStatColumn(following, "Following")
                              ],
                            ),
                            FirebaseAuth.instance.currentUser!.uid==widget.uid?FollowButton(
                              backgroundColor: mobileBackgroundColor,
                              borderColor: Colors.grey,
                              text: "Sign Out",
                              textColor: primaryColor,
                              function: () async {
                                await AuthMethods().signOut();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
                              },) : isfollowing?FollowButton(
                              backgroundColor: Colors.white,
                              borderColor: Colors.grey,
                              text: "Unfollow",
                              textColor: Colors.black,
                              function: ()async{
                                await FirestoreMethod().followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid!);
                                setState(() {
                                  isfollowing = false;
                                  followers--;
                                });
                              },
                            ):FollowButton(
                                backgroundColor: Colors.blue,
                                borderColor: Colors.grey,
                                text: "Follow",
                                textColor: primaryColor,
                                function: ()async{
                                  await FirestoreMethod().followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid!);
                                  setState(() {
                                    isfollowing = true;
                                    followers++;
                                  });

                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        userData["username"]!=null?userData["username"]:"username",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        userData["email"]!=null?userData["email"]:"email@gmail.com",
                      )),
                  const Divider(),
                  FutureBuilder(
                      future: FirebaseFirestore.instance.collection("post").where("uid" , isEqualTo :widget.uid).get(),
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child:CircularProgressIndicator());
                        }

                        return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing:5,
                                childAspectRatio: 1,
                                mainAxisSpacing: 1.5
                            ),
                            itemBuilder: (context,index){
                              DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                              return Container(
                                child: Image(image: NetworkImage(
                                    snap["postUrl"]
                                ),
                                    fit: BoxFit.cover
                                ),

                              );
                            }


                        );

                      }

                  )
                ],
              ),
            )
          ],
        ),
      );
  }
}