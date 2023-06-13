import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final Color? textColor;

  LanguageButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(16),
          elevation: 8,
          backgroundColor: color ?? Colors.black87,
          primary: Colors.deepOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 36,
            color: textColor ?? Colors.white,
          ),
        ),
        onPressed: onPressed as void Function()?,
      ),
    );
  }
}