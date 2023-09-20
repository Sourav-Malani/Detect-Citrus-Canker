import 'dart:async';
import 'package:flutter/material.dart';
import 'Languages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SwitchLanguageScreen()));
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFA5FF7A),
                Color(0xFF73F833),
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/icon/icon.png",
                  height: 300.0,
                  width: 300.0,
                ),
                Text(
                  "Canker Detection\n at your fingertips",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
              ],
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}



// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     );
//     _controller.forward();
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacementNamed(context, '/onboarding');
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade700,
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ScaleTransition(
//                 scale: _animation,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Image.asset(
//                       'assets/icon/icon.png',
//                       width: 64.0,
//                       height: 64.0,
//                     ),
//                     const SizedBox(width: 16.0),
//                     Text(
//                       'Canker Detect',
//                       style: TextStyle(
//                         fontSize: 48.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontFamily: 'Pacifico',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),
//               Text(
//                 'Making Canker Easy to Detect',
//                 style: TextStyle(
//                   fontSize: 24.0,
//                   color: Colors.white,
//                   fontFamily: 'Montserrat',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
