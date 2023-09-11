import 'package:flutter/material.dart';
import 'constants.dart';

class CustomTextfield3 extends StatelessWidget {
  final IconData icon;
  final bool obscureText;
  final String hintText;
  final Function(String)? onChanged;

  CustomTextfield3({
    Key? key,
    required this.icon,
    required this.obscureText,
    required this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(
        color: Constants.blackColor,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          icon,
          color: Constants.blackColor.withOpacity(.3),
        ),
        hintText: hintText,
      ),
      cursorColor: Constants.blackColor.withOpacity(.5),
      onChanged: onChanged,
    );
  }
}
