//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/providers/user_providers.dart';
import 'package:canker_detect/Community3/responsive/global_variables.dart';
//import 'package:canker_detect/Community3/screens/add_post_screen.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:canker_detect/Community3/resources/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        body: PageView(
          children: homeScreenItems,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: _page == 0 ? primaryColor : secondaryColor),
                label: "",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    color: _page == 1 ? primaryColor : secondaryColor),
                label: "",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,
                    color: _page == 2 ? primaryColor : secondaryColor),
                label: "",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.cloud,
                    color: _page == 3 ? primaryColor : secondaryColor),
                label: "",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: _page == 4 ? primaryColor : secondaryColor),
                label: "",
                backgroundColor: primaryColor),
          ],
          onTap: navigationTapped,
        ));
  }
}
