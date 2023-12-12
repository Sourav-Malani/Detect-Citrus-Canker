import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:canker_detect/Community3/resources/auth_methods.dart';
import 'package:canker_detect/Community3/responsive/webscreenlayout.dart';
import 'package:canker_detect/Community3/screens/login_screen.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:canker_detect/Community3/widgets/text_field_input.dart';

import '../responsive/mobilescreenlayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void singUpUser() async {
    setState(() {
      isLoading = true;
    });
    // Perform validation checks first
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        _image == null) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
          "SignupEmptyFieldsError".tr(), context);
      return; // Exit the function early
    }

    String res = await AuthMethods().signUpUser(
      email: email,
      password: password,
      username: username,
      file: _image!,
    );

    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              mobilescreenlayout: MobileScreenLayout(),
              webscreenlayout: WebScreenLayout())));
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigatetologin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CankerDetect",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 24),
            Stack(children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64, backgroundImage: MemoryImage(_image!))
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                          "https://t3.ftcdn.net/jpg/03/46/83/96/240_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
                    ),
              Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 25,
                    ),
                  ))
            ]),
            const SizedBox(height: 24),
            TextFieldInput(
              textEditingController: _usernameController,
              hintText: "UsernameSignup".tr(),
              textInputType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 24),
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Email-text".tr(),
                textInputType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: "Password-text".tr(),
              textInputType: TextInputType.visiblePassword,
              ispass: true,
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: singUpUser,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      child:  Text("SignUp_text".tr()),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: ShapeDecoration(
                          color: blueColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child:  Text("HaveAnAccount_text".tr()),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: navigatetologin,
                  child: Container(
                    child:  Text(
                      "Login_text".tr(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
