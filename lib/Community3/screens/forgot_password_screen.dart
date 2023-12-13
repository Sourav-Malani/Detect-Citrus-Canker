import 'package:canker_detect/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/resources/auth_methods.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  void resetPassword(BuildContext context) async {
    String email = emailController.text;

    String result = await AuthMethods().forgotPassword(email: email);

    if (result == "success") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Password Reset Email Sent"),
            content: Text("An email with instructions to reset your password has been sent to $email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Close the Forgot Password screen
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Password Reset Error"),
            content: Text(result),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: mobileBackgroundColor,
        leading: Image.asset('assets/icon/icon.png', height: 20, width: 20),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icon/icon.png', // Replace this with your image path
              height: 200, // Set the desired height
              width: 200, // Adjust the width to stretch across the screen
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Forgot Your Password?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Enter your email address to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => resetPassword(context), // Pass the context
                    child: Text("Reset Password"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Make the button round
                      ),
                      primary: mobileBackgroundColor, // Change background color
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
