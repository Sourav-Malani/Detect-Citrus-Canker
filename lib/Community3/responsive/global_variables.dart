import 'package:canker_detect/Community3/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:canker_detect/Community3/screens/feed_screens.dart';
import 'package:canker_detect/Community3/screens/profileScreen.dart';
import 'package:canker_detect/Community3/screens/search_screen.dart';
import 'package:canker_detect/WeatherPage.dart';

import '../screens/add_post_screen.dart';

const webscreensize = 600;

final homeScreenItems = [
  ProductCardWidget(),
  SearchScreen(),
  AddPostScreen(),
  WeatherPage(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)
];
