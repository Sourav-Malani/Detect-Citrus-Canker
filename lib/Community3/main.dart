import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:canker_detect/Community3/providers/user_providers.dart';
import 'package:canker_detect/Community3/responsive/mobilescreenlayout.dart';
import 'package:canker_detect/Community3/responsive/responsive_layout_screen.dart';
import 'package:canker_detect/Community3/responsive/webscreenlayout.dart';
import 'package:canker_detect/Community3/screens/login_screen.dart';
//import 'package:canker_detect/Community3/screens/signupscreen.dart';
import 'package:canker_detect/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

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
        theme: ThemeData.dark()
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
}
