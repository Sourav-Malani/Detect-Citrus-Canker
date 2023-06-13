import 'Controller/language_controller.dart';
import 'package:canker_detect/Widgets/languagebutton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'onboarding_screen.dart';
class Languages extends StatelessWidget {
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
              Image.asset('assets/icon/icon.png',
              height: 40,width:40),
              Text(
                'home_description'.tr(),
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'languages_btn_english'.tr(),
                onPressed: () {
                  context.locale = Locale('en', 'US');
                  controller.onLanguageChanged();
                },
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'languages_btn_urdu'.tr(),
                onPressed: () {
                  context.locale = Locale('ur', 'PK');
                  controller.onLanguageChanged();
                },
              ),
              SizedBox(height: 32),
              LanguageButton(
                text: 'languages_btn_hindi'.tr(),
                onPressed: () {
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
