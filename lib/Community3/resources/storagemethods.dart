import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
// adding image to firebase

  Future<String> uploadImageToStorage(
      String childname, Uint8List file, bool ispost) async {
    Reference ref =
    _storage.ref().child(childname).child(_auth.currentUser!.uid);


    if(ispost){
      String id = const Uuid().v1();
      ref= ref.child(id);

    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }




}