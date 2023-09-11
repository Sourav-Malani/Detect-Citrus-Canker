import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:canker_detect/Community3/resources/firestore_method.dart';
import 'package:canker_detect/Community3/resources/user.dart';
import 'package:canker_detect/Community3/screens/commentScreen.dart';
import 'package:canker_detect/utils/colors.dart';
//import 'package:canker_detect/utils/utils.dart';
import 'package:canker_detect/Community3/widgets/the_animation.dart';
import 'package:provider/provider.dart';

import '../providers/user_providers.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating=false;
  int commentLen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("post")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();
      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.snap["profImage"])),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.snap["username"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: ListView(
                              padding:
                              const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: ["Delete"]
                                  .map((e) => InkWell(
                                  onTap: () async{

                                    FirestoreMethod().deletePost(widget.snap["postId"]);
                                    Navigator.of(context).pop();
                                  }

                                  ,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  )))
                                  .toList(),
                            ),
                          ));
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),

          GestureDetector(

            onDoubleTap: () async{
              await FirestoreMethod().likePost(widget.snap["postId"],user.uid,widget.snap["likes"]);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
                alignment: Alignment.center,
                children : [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap["postUrl"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration( milliseconds : 200),
                    opacity: isLikeAnimating?1:0,
                    child: LikeAnimation(
                      child: const Icon(Icons.favorite_outline,color: Colors.white,size:100 ,),
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                          milliseconds: 400
                      ),
                      onEnd: (){
                        setState(() {
                          isLikeAnimating = false;
                        });

                      },
                    ),
                  )
                ]
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user.username),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethod().likePost(widget.snap["postId"],user.uid,widget.snap["likes"]);

                    },
                    icon: widget.snap['likes'].contains(user.uid)?const Icon(Icons.favorite,color:Colors.red):
                    const Icon(Icons.favorite_border)
                ),
              ),
              IconButton(
                  onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => CommentSection(snap: widget.snap),)), icon: const Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
                  )),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 2),
                  alignment: Alignment.bottomLeft,
                  child: DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap["likes"].length} likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(style: TextStyle(color: Colors.white), children: [
                TextSpan(
                    text: widget.snap["username"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' ${widget.snap["description"]}',style: const TextStyle(color:Colors.black)),
              ]),
            ),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => CommentSection(snap: widget.snap),)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.bottomLeft,
              child:  Text("view all ${commentLen}",
                  style: TextStyle(fontSize: 16, color: secondaryColor)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.bottomLeft,
            child: Text( DateFormat.yMMMd().format(widget.snap['datePublished'].toDate())),
          )
        ],
      ),
    );
  }
}