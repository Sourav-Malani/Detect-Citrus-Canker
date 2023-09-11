import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{
  void toastMessage(String messsage){
    Fluttertoast.showToast(
      msg:messsage,
      toastLength:Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb:1,
      backgroundColor: Colors.red,
      textColor:Colors.white,
      fontSize:16.0

    );
  }
}