import 'package:canker_detect/Community3/screens/feed_screens.dart';
import 'package:canker_detect/WeatherPage.dart';
import 'package:canker_detect/Languages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/providers/user_providers.dart';
import 'package:canker_detect/Community3/responsive/mobilescreenlayout.dart';
import 'package:canker_detect/Community3/responsive/responsive_layout_screen.dart';
import 'package:canker_detect/Community3/responsive/webscreenlayout.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:canker_detect/SplashScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Controller/language_controller.dart';
import 'widget/plant_recogniser.dart';
// import 'package:canker_detect/Community3/screens/homescreen.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:canker_detect/onboarding_screen.dart';
// import 'package:canker_detect/Community3/screens/login_screen.dart';
// import 'package:canker_detect/Community3/screens/signupscreen.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:canker_detect/languagescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('ur', 'PK'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: const MyApp2(),
    ),
  );
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CankerDetect',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData.light()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        routes: {
          '/weatherPage': (context) => WeatherPage(),
          '/CankerDetect': (context) => const PlantRecogniser(),
          '/feedScreen': (context) => FeedScreen(),
          '/mobileScreenLayout': (context) => MobileScreenLayout(),
          // Define more routes as needed
        },
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show the splash screen while waiting.
              return SplashScreen();
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            } else {
              // Check the user's authentication status.
              final user = snapshot.data;
              if (user != null) {
                return ResponsiveLayout(
                  mobilescreenlayout: MobileScreenLayout(),
                  webscreenlayout: WebScreenLayout(),
                );
              } else {
                return SwitchLanguageScreen();
              }
            }
          },
        ),
      ),
    );
  }
}
