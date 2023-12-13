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
          "Please fill in all the fields and select an image.", context);
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
      appBar: AppBar(
        title: Text("Signup"),
        backgroundColor: mobileBackgroundColor, // Replace with your app's theme color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                // Your icon widget (replace this with your own image)
                Image.asset(
                  'assets/icon/icon.png',
                  width: 200, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                ),
                SizedBox(height: 24),
                Text(
                  "CankerDetect",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24),
                Stack(
                  children: [
                    if (_image != null)
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    else
                      CircleAvatar(
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
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: singUpUser,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                    child: Text("Sign Up",style: TextStyle(
                      color: Colors.white
                    ),),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: ShapeDecoration(
                      color: mobileBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Have an account",style: TextStyle(
                        color: Colors.grey
                      ),),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: navigatetologin,
                      child: Container(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24), // Additional space at the end
              ],
            ),
          ),
        ),
      ),
    );
  }


}
