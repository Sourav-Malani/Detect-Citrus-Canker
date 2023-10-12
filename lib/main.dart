/*
import 'package:canker_detect/firebase_options.dart';
import 'package:canker_detect/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  await Firebase.initializeApp();
  
  runApp( EasyLocalization(
        supportedLocales: [
          Locale('en', 'US'),
          Locale('hi', 'IN'),
          Locale('ur', 'PK'),
          
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
    child:  const MyApp()
    ),
    );
    
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return MultiProvider (
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
        '/switchlanguagescreen':(context) => SwitchLanguageScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/next_page': (context) => const NextPage(),
        '/login': (context) => SignIn(),
        // '/profile': (context) => ProfilePage(),
      },
     
      
      ),
      
    );
  }
}
*/

import 'package:canker_detect/Community3/screens/feed_screens.dart';
import 'package:canker_detect/Community3/screens/homescreen.dart';
import 'package:canker_detect/WeatherPage.dart';
import 'package:canker_detect/widget/plant_recogniser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:canker_detect/Languages.dart';
import 'package:canker_detect/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/providers/user_providers.dart';
import 'package:canker_detect/Community3/responsive/mobilescreenlayout.dart';
import 'package:canker_detect/Community3/responsive/responsive_layout_screen.dart';
import 'package:canker_detect/Community3/responsive/webscreenlayout.dart';
import 'package:canker_detect/Community3/screens/login_screen.dart';
import 'package:canker_detect/Community3/screens/signupscreen.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:canker_detect/SplashScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Controller/language_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:canker_detect/languagescreen.dart';
//import 'package:canker_detect/MapScreen/google_map_styling_screen.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:canker_detect/WeatherNew/src/app.dart';
import 'package:canker_detect/WeatherNew/src/screen/home.dart';
import 'package:canker_detect/WeatherNew/src/controllers/theme_controller.dart';



void main() async {
  await Hive.initFlutter();
  await Hive.openBox('search-history');
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true, // Enable offline data
  );
  // Create the theme controller
  var themeController = ThemeController();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('ur', 'PK'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: CustomMaterialApp(themeController: themeController),
    ),
  );
}

class CustomMaterialApp extends StatelessWidget {
  final ThemeController themeController;

  CustomMaterialApp({required this.themeController});

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
      child: StreamBuilder(
        stream: themeController.stream,
        builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: snapshot.data,
            darkTheme: ThemeData.dark(), // Set the dark theme
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routes: {
              '/weatherPage': (context) => WeatherPage(),
              '/feedScreen': (context) => FeedScreen(),
              '/mobileScreenLayout': (context) => MobileScreenLayout(),
              '/PlantRecogniser': (context) => PlantRecogniser(), // Include the PlantRecogniser page
              '/NewWeather': (context) => Home(themeController),
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
          );
        },
      ),
    );
  }
}



/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CankerDetect',
        theme: ThemeData.light()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ResponsiveLayout(
                    mobilescreenlayout: MobileScreenLayout(),
                    webscreenlayout: WebScreenLayout());
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return LoginScreen();
          },
        ),
        // home: ResponsiveLayout(mobilescreenlayout: MobileScreenLayout(), webscreenlayout:WebScreenLayout() ),
      ),
    );
  }
}*/
