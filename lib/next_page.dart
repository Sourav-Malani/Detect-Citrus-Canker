import 'package:flutter/material.dart';
import 'CameraPage.dart';
import 'package:camera/camera.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'WeatherPage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'profile_page.dart';

import 'app.dart';

class NextPage extends StatefulWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  late User? _user;
  String _userName = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _userName = _user?.displayName ?? '';
  }

  final List<Widget> _tabs = [
    MainApp(), // CankerDetect
    Center(child: Text('Community_text'.tr(), style: TextStyle(fontSize: 18))),
    Center(child: Text('Weather_text'.tr(), style: TextStyle(fontSize: 18))),
    Center(child: Text('Camera_text'.tr(), style: TextStyle(fontSize: 18))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage_text'.tr(), style: TextStyle(fontSize: 20)),
        backgroundColor: Color(0xff296e48),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Constants.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Options_text'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile_text'.tr()),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                if (_user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(user: _user),
                    ),
                  ); // Navigate to the profile page
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings_text'.tr()),
              onTap: () {
                // Navigate to the settings page.
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut_text'.tr()),
              onTap: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 78, 245, 84),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            selectedIndex: _currentIndex,
            backgroundColor: Color.fromARGB(255, 78, 245, 84),
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Color.fromARGB(255, 139, 206, 94),
            color: Colors.white,
            tabs: [
              GButton(
                icon: Icons.search,
                text: 'Detect',
              ),
              GButton(
                icon: Icons.people,
                text: 'Community_text'.tr(),
              ),
              GButton(
                icon: Icons.cloud,
                text: 'Weather_text'.tr(),
              ),
            ],
            onTabChange: (index) {
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherPage(),
                  ),
                );
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.camera_alt),
      //   onPressed: () async {
      //     final cameras = await availableCameras();
      //     final camera = cameras.first;
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => CameraPage(camera: camera)),
      //     );
      //   },
      // ),
    );
  }
}
