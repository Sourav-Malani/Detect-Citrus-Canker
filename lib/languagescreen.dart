import 'Controller/language_controller.dart';
import 'package:canker_detect/Widgets/languagebutton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'onboarding_screen.dart';

class Languages extends StatefulWidget {
  @override
  _LanguagesState createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  String selectedLanguage = 'English'; // Set "English" as the default selected language

  @override
  Widget build(BuildContext context) {
    LanguageController controller = context.read<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8), // Adjust padding as needed
              child: Image.asset('assets/icon/icon.png', height: 40, width: 40), // Increase the size here
            ),
            SizedBox(width: 8),
            Text("Languages"),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8), // Adjust padding as needed
                child: Image.asset('assets/icon/icon.png', height: 80, width: 80), // Increase the size here
              ),
              Text(
                'home_description'.tr(),
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'English',
                color: selectedLanguage == 'English' ? Colors.lightGreen.shade400 : null,
                onPressed: () {
                  setState(() {
                    selectedLanguage = 'English';
                  });
                  context.locale = Locale('en', 'US');
                  controller.onLanguageChanged();
                },
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'اردو',
                color: selectedLanguage == 'Urdu' ? Colors.lightGreen.shade400 : null,
                onPressed: () {
                  setState(() {
                    selectedLanguage = 'Urdu';
                  });
                  context.locale = Locale('ur', 'PK');
                  controller.onLanguageChanged();
                },
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'हिंदी',
                color: selectedLanguage == 'Hindi' ? Colors.lightGreen.shade400 : null,
                onPressed: () {
                  setState(() {
                    selectedLanguage = 'Hindi';
                  });
                  context.locale = Locale('hi', 'IN');
                  controller.onLanguageChanged();
                },
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'confirm_selection'.tr(),
                color: Colors.green,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnboardingScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
