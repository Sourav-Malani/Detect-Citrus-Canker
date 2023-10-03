import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/resources/storagemethods.dart';
import 'package:canker_detect/Community3/resources/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Forgot Password
  Future<String> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        return "The email is badly formatted";
      } else if (err.code == "user-not-found") {
        return "No user found with this email";
      } else {
        return "An error occurred. Please try again later.";
      }
    } catch (err) {
      return "An error occurred. Please try again later.";
    }
  }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //signupuser

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      //register user

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      print(cred.user!.uid);

      String photoUrl = await StorageMethods()
          .uploadImageToStorage("profilepics", file, false);

      model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          followers: [],
          following: [],
          photoUrl: photoUrl);

      //add user to database
      await _firestore
          .collection("users")
          .doc(cred.user!.uid)
          .set(user.toJson());

      res = "success";
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "The email is badly formatted";
      } else if (err.code == "weak-password") {
        res = "Password should be at least 6 digits";
      } else if (err.code == "email-already-in-use") {
        return "Email is already in use. Please use a different email.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login in user

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
