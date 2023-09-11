import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImages;
  final likes;

  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImages,
      required this.likes});

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "profImage": profImages,
        "likes": likes,
        "postUrl": postUrl
      };

  static Post fromSnap(DocumentSnapshot snap) {
    // ignore: unused_local_variable
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snap["description"],
        uid: snap["uid"],
        username: snap["username"],
        postId: snap["postId"],
        datePublished: snap["datePublished"],
        profImages: snap["profImages"],
        likes: snap["likes"],
        postUrl: snap["postUrl"]);
  }
}
