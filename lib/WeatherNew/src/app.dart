// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:canker_detect/WeatherNew/src/screen/home.dart';
import 'controllers/theme_controller.dart';

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  var themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: themeController.stream,
        builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Home(themeController),
            theme: snapshot.data,
          );
        });
  }
}
