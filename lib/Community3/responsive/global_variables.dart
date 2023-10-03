import 'package:canker_detect/Community3/screens/homescreen.dart';
import 'package:canker_detect/widget/plant_recogniser.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:canker_detect/Community3/screens/profileScreen.dart';
import 'package:canker_detect/Community3/screens/search_screen.dart';
import '../screens/add_post_screen.dart';
import 'package:canker_detect/WeatherNew/src/screen/home.dart';
import 'package:canker_detect/WeatherNew/src/controllers/theme_controller.dart';

const webscreensize = 600;
var themeController = ThemeController();

final homeScreenItems = [
  ProductCardWidget(),
  PlantRecogniser(),
  //SearchScreen(),
  AddPostScreen(),
  Home(themeController),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)




];
