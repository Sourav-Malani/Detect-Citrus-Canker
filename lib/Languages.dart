import 'Controller/language_controller.dart';
import 'languagescreen.dart';
import 'package:canker_detect/Widgets/languagebutton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
//import 'languagescreen.dart';

class SwitchLanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/icon/icon.png', height: 20, width: 20),
        title: Text('Language Selection'),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Switch Language',
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
              SizedBox(height: 24),
              Text(
                'home_description'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 24),
              LanguageButton(
                text: 'Language-buttonText'.tr(),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Languages(),
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
