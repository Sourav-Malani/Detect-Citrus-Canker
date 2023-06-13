import 'package:canker_detect/firebase_options.dart';
import 'package:canker_detect/profile_page.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'next_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';
import 'signin_page.dart';
import 'splashscreen.dart'; // import the splashscreen.dart file
import 'onboarding_screen.dart';
import 'package:get/get.dart';
import 'Controller/controller.dart';
import 'Widgets/header_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'WeatherPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Languages.dart';
import 'Controller/language_controller.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('ur', 'PK'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageController()),
      ],
      child: MaterialApp(
        title: 'Canker Detection',

        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        initialRoute: '/splash', // set the initial route
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/switchlanguagescreen': (context) => SwitchLanguageScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/next_page': (context) => const NextPage(),
          '/login': (context) => SignIn(),
          // '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}
