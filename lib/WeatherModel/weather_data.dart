import 'package:canker_detect/WeatherModel/weather_data_current.dart';
import 'package:canker_detect/WeatherModel/weather_data_hourly.dart';
import 'package:canker_detect/WeatherModel/weather_data_daily.dart';
class WeatherData{
  final WeatherDataCurrent? current;
  final WeatherDataHourly? hourly;
  final WeatherDataDaily? daily;
  WeatherData([this.current,this.hourly, this.daily]);

  //function to fetch the value

  WeatherDataCurrent getCurrentWeather()=>current!;
  WeatherDataHourly getHourlyWeather()=>hourly!;
  WeatherDataDaily getDailyWeather()=>daily!;
}