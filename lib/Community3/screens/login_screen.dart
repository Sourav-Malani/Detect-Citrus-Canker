import 'package:canker_detect/Community3/screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/resources/auth_methods.dart';
//import 'package:canker_detect/Community3/screens/homescreen.dart';
import 'package:canker_detect/Community3/screens/signupscreen.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:canker_detect/Community3/widgets/text_field_input.dart';

import '../responsive/mobilescreenlayout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webscreenlayout.dart';
import 'package:quickalert/quickalert.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isloading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    // Check if the internet is available
    bool isInternetAvailable = await checkInternetConnectivity();
    if (!isInternetAvailable) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'No Internet',
        text: 'Please check your internet connection.',
      );
      setState(() {
        isloading = false;
      });
      return;
    }

    String res = await AuthMethods().loginUser(email: email, password: password);

    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResponsiveLayout(
          mobilescreenlayout: MobileScreenLayout(),
          webscreenlayout: WebScreenLayout(),
        ),
      ));
    } else if (res == "incorrect_password_or_email") {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "OOPS_Text".tr(),
        text: "IncorrectPassEmail_Text".tr(),
      );
    } else {
      // Handle other possible errors here
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "OOPS_Text".tr(),
        text: "InvalidPassword".tr(),
      );
    }
    setState(() {
      isloading = false;
    });
  }


  Future<bool> checkInternetConnectivity() async {
    final ConnectivityResult connectivityResult =
    await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  void navigatetosignup() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SignUpScreen(),
    ));
  }
  void navigatetoForgot() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ForgotPasswordScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login_text".tr())),
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
            const SizedBox(height: 25),
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
              onTap: loginUser,
              child: isloading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      child: Text("Login_text".tr()),
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
                  child:  Text("NewtoCankerDetect_text".tr()),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: navigatetosignup,
                  child: Container(
                    child:  Text(
                      "SignUp_text".tr(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child:  Text("ForgotPassword_text".tr()),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: navigatetoForgot,
                  child: Container(
                    child:  Text(
                      "ResetHere_text".tr(),
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
