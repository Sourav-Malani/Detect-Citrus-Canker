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
  Map<String, Color> buttonColors = {
    'languages_btn_english': Colors.grey,
    'languages_btn_urdu': Colors.grey,
    'languages_btn_hindi': Colors.grey,
  };
  void resetButtonColors(String selectedButton) {
    for (var button in buttonColors.keys) {
      if (button != selectedButton) {
        setState(() {
          buttonColors[button] = Colors.grey; // Reset other buttons to default color
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    LanguageController controller = context.read<LanguageController>();

    return Scaffold(
      appBar: AppBar(title: Text("Languages")),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icon/icon.png', height: 40, width: 40),
              Text(
                'home_description'.tr(),
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'languages_btn_english'.tr(),
                color: buttonColors['languages_btn_english'] ?? Colors.grey,
                onPressed: () {
                  context.locale = Locale('en', 'US');
                  controller.onLanguageChanged();
                  resetButtonColors('languages_btn_english'); // Reset other button colors
                  setState(() {
                    buttonColors['languages_btn_english'] = Colors.blue;
                  });
                },
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'languages_btn_urdu'.tr(),
                color: buttonColors['languages_btn_urdu'] ?? Colors.grey,
                onPressed: () {
                  context.locale = Locale('ur', 'PK');
                  controller.onLanguageChanged();
                  resetButtonColors('languages_btn_urdu'); // Reset other button colors

                  setState(() {
                    buttonColors['languages_btn_urdu'] = Colors.blue;
                  });
                },
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'languages_btn_hindi'.tr(),
                color: buttonColors['languages_btn_hindi'] ?? Colors.grey,
                onPressed: () {
                  context.locale = Locale('hi', 'IN');
                  controller.onLanguageChanged();
                  resetButtonColors('languages_btn_hindi'); // Reset other button colors
                  setState(() {
                    buttonColors['languages_btn_hindi'] = Colors.blue;
                  });
                },
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'confirm_selection'.tr(),
                color: Colors.green,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen(),
                    ),
                  );
                  setState(() {
                    // Change the color of the confirmation button if needed
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
