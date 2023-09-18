import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../controllers/weather_controller.dart';

class MiscellaneousWeather extends StatelessWidget {
  final WeatherController wc;
  final BuildContext context;
  const MiscellaneousWeather({
    Key? key,
    required this.wc,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return miscellaneousWeather();
  }

  Widget miscellaneousWeather() {
    return SizedBox(
      height: 290,
      // color: Colors.pink,
      child: Card(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: Column(
          children: [
            customTileList(
              WeatherIcons.day_sunny,
              "UV Light",
              wc.simplifyUV(
                wc.currentWeatherExtra['uvi'],
              ),
            ),
            customTileList(
                WeatherIcons.sunrise,
                "Sunrise",
                wc.dateFormatTimeOfDay(
                  wc.convertToCurrentTimeZone(
                    wc.currentWeatherExtra['sunrise'],
                  ),
                )),
            customTileList(
                WeatherIcons.sunset,
                "Sunset",
                wc.dateFormatTimeOfDay(
                  wc.convertToCurrentTimeZone(
                    wc.currentWeatherExtra['sunset'],
                  ),
                )),
            customTileList(
              WeatherIcons.humidity,
              "Humidity",
              wc.currentWeatherExtra['humidity'].toString() + "%",
            ),
            customTileList(
              WeatherIcons.cloud,
              "Cloudiness",
              wc.currentWeatherExtra['clouds'].toString() + "%",
            ),
            customTileList(
              WeatherIcons.windy,
              "Wind Speed",
              wc.currentWeatherExtra['wind_speed'].toString() + " m/s",
            ),
            customTileList(
              WeatherIcons.barometer,
              "Pressure",
              wc.currentWeatherExtra['pressure'].toString() + " hPa",
            ),
          ],
        ),
      )),
    );
  }

  Widget customTileList(IconData icon, String title, String result) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 38,
          child: Row(
            children: [
              BoxedIcon(
                icon,
                size: 22,
                color: Theme.of(context).textTheme.headline3?.color,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(title),
            ],
          ),
        ),
        Text(
          result,
        ),
      ],
    );
  }
}
