import 'package:flutter/material.dart'; // import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:canker_detect/WeatherNew/src/app.dart';
// import 'package:timezone/timezone.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('search-history');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
