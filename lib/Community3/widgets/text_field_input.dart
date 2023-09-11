import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool ispass;
  final String hintText;
  final TextInputType textInputType;

  TextFieldInput(
      {required this.textEditingController,
        this.ispass = false,
        required this.hintText,
        required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final inputborder =
    OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          border: inputborder,
          focusedBorder: inputborder,
          enabledBorder: inputborder,
          filled: true,
          contentPadding: EdgeInsets.all(8)),
      keyboardType: textInputType,
      obscureText: ispass,
    );
  }
}