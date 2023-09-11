import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canker_detect/Community3/resources/post.dart';
import 'package:canker_detect/Community3/resources/storagemethods.dart';
//import 'package:canker_detect/utils/utils.dart';
import 'package:uuid/uuid.dart';
//import 'package:flutter/material.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//upload post

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String profImages, String username) async {
    String res = "Some error occured";

    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        postId: postId,
        postUrl: photoUrl,
        profImages: profImages,
        username: username,
        uid: uid,
        likes: [],
        datePublished: DateTime.now(),
      );

      _firestore.collection("post").doc(postId).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection("post").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection("post").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some Error Occured";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("post")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilepic": profilePic,
          "name": name,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
        res = "success";
      } else {
        print("Text is empty");
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("post").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> followUser(String uid,String followId) async{

    try{
      DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];
      if(following.contains(followId)){
        await _firestore.collection("users").doc(followId).update({
          "followers" : FieldValue.arrayRemove([uid])
        });
        await _firestore.collection("users").doc(uid).update({
          "following" : FieldValue.arrayRemove([followId])
        });
      }else{
        await _firestore.collection("users").doc(followId).update({
          "followers" : FieldValue.arrayUnion([uid])
        });
        await _firestore.collection("users").doc(uid).update({
          "following" : FieldValue.arrayUnion([followId])
        });

      }

    }catch(e){
      print(e.toString());
    }



  }
}