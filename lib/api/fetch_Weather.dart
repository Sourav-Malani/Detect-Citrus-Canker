import 'dart:convert';
import 'package:canker_detect/WeatherModel/weather_data_hourly.dart';
import 'package:canker_detect/utils/api_url.dart';
import 'package:canker_detect/WeatherModel/weather_data.dart';
//import 'package:canker_detect/api/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:canker_detect/WeatherModel/weather_data_current.dart';
import 'package:canker_detect/WeatherModel/weather_data_daily.dart';


class FetchWeatherAPI{
  WeatherData? weatherData;
  Future<WeatherData> processData(lat,lon) async {
    var response = await http.get(Uri.parse(apiURL(lat,lon)));
    var jsonString= jsonDecode(response.body);
    weatherData=WeatherData(WeatherDataCurrent.fromJson(jsonString),
    WeatherDataHourly.fromJson(jsonString),
    WeatherDataDaily.fromJson(jsonString));

    return weatherData!;
}
}
