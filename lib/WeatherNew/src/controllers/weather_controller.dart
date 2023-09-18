import 'dart:async';

import 'package:intl/intl.dart';
import 'package:canker_detect/WeatherNew/src/controllers/recent_search_controller.dart';
import 'package:canker_detect/WeatherNew/src/controllers/theme_controller.dart';

import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class WeatherController {
  final RecentSearchController _rsc = RecentSearchController();
  late final ThemeController themeController;
  late Weather currentWeather;
  late List<dynamic> hourlyWeather;
  late List<dynamic> dailyWeather;
  late String timeZone;
  late Map<String, dynamic> currentWeatherExtra;
  late String cityName;
  final key = '6994e452939894a4cf970d7fbafe71b8';
  late final WeatherFactory _wf;

  final StreamController<String?> _controller = StreamController();
  Stream<String?> get stream => _controller.stream;

  WeatherController(ThemeController tc) {
    _wf = WeatherFactory(key);
    setCity(_rsc.searches.isEmpty ? "Islamabad" : _rsc.searches.last);
    cityName = "Islamabad";
    themeController = tc;
    // _setWeather();
  }
  void setCity(String city) {
    cityName = city;
    _setWeather();
  }

  void _setWeather() async {
    _controller.add(null);
    tz.initializeTimeZones();

    try {
      http.Response response = await apiRequest();

      if (response.statusCode == 200) {
        _setWeatherDetails(response);
        _controller.add("success");
      } else {
        print(response.statusCode);
        _controller.addError(Future.error(response.statusCode));
      }
    } catch (e) {
      print(e);
      _controller.addError((e));
    }
  }

  void _setWeatherDetails(http.Response response) {
    final jsonResponse = convert.jsonDecode(response.body);

    hourlyWeather = jsonResponse['hourly'];
    dailyWeather = jsonResponse['daily'];
    currentWeatherExtra = jsonResponse['current'];
    timeZone = jsonResponse['timezone'];

    int cityTimeZone = _getTimeZoneHour(timeZone);
    themeController.setTimeNow((cityTimeZone));
  }

  Future<http.Response> apiRequest() async {
    currentWeather = await _wf.currentWeatherByCityName(cityName);

    final url = Uri.https(
      'api.openweathermap.org',
      'data/2.5/onecall',
      {
        'lat': currentWeather.latitude.toString(),
        'lon': currentWeather.longitude.toString(),
        'exclude': 'minutely',
        'units': 'metric',
        'appid': key,
      },
    );

    final response = await http.get(url);
    return response;
  }

  String simplifyUV(uv) {
    if (uv >= 11) {
      return "Extemely High";
    } else if (uv > 7) {
      return "Very High";
    } else if (uv > 5) {
      return "High";
    } else if (uv > 2) {
      return "Medium";
    } else if (uv <= 2) {
      return "Low";
    } else {
      return "Could not calculate UV";
    }
  }

  String temperatureTrim(var temperature) {
    return temperature.toString().replaceAll(" Celsius", "°");
  }

  String dateFormatHour(DateTime date) {
    return DateFormat(DateFormat.HOUR24).format(date).toString();
  }

  String dateFormatWeek(int timesamp, [int index = 0]) {
    return index == 0
        ? "Today"
        : DateFormat.EEEE()
            .format(DateTime.fromMillisecondsSinceEpoch(timesamp * 1000))
            .toString();
  }

  String dateFormatTimeOfDay(DateTime timeNow) {
    return DateFormat('hh:mm aaa').format(
      (timeNow),
    );
  }

  DateTime getPSTTime() {
    try {
      final DateTime now = DateTime.now();
      final pacificTimeZone = tz.getLocation(timeZone);
      var tzz = tz.TZDateTime.from(now, pacificTimeZone);
      // print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      // print(tzz);
      return tzz;
    } catch (e) {
      return DateTime.now();
    }
  }

  int _getTimeZoneHour(timeZone) {
    return int.parse(DateFormat(DateFormat.HOUR24).format(getPSTTime()));
  }

  DateTime convertToCurrentTimeZone(int hourlyWeather) {
    // var timesamp = hourlyWeather * 1000;
    var date = DateTime.fromMillisecondsSinceEpoch(hourlyWeather * 1000);

    try {
      // final DateTime now = DateTime.now();
      final pacificTimeZone = tz.getLocation(timeZone);
      var dateNow = tz.TZDateTime.from(date, pacificTimeZone);
      // DateTime(dateNow);
      // print(" ${dateFormatHourMeridiem(dateNow.millisecondsSinceEpoch)}");
      // print(" ${(dateNow)}");

      // print(" ${}");
      return dateNow;
    } catch (e) {
      // print("EROOOOOOOOOOOOOOOOOOOOOOOOOOOR $e");
      return DateTime.now();
    }
  }

  String dateFormatHourMeridiem(DateTime timeNow) {
    return DateFormat("h aaa").format(timeNow);
  }
}
