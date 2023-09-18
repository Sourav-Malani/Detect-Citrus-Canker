import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/weather_controller.dart';
import 'hourly_weather.dart';
import '../../model/string_extension.dart';

class CurrentWeather extends StatelessWidget {
  final WeatherController wc;

  const CurrentWeather({
    Key? key,
    required this.wc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentWeather(context);
  }

  Widget currentWeather(context) {
    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).textTheme.headline3?.color,
                    ),
                    Text(
                      wc.currentWeather.areaName.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                Text(DateFormat("E, MMM d  hh:mm aaa").format(wc.getPSTTime())),
              ],
            ),
          ),

          Container(
            // color: Colors.pink,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 64,
                      // color: Colors.red,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Image.network(
                          "http://openweathermap.org/img/wn/" +
                              wc.currentWeather.weatherIcon.toString() +
                              "@2x.png",

                          // color: Colors.transparent,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        wc.temperatureTrim(wc.currentWeather.temperature),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          wc.currentWeather.weatherDescription
                              .toString()
                              .capitalize(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Text(
                        wc.temperatureTrim(wc.currentWeather.tempMin) +
                            "/" +
                            wc.temperatureTrim(wc.currentWeather.tempMax),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "Feels like " +
                            wc.temperatureTrim(wc.currentWeather.tempFeelsLike),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          HourlyWeather(
            wc: wc,
          ),

          // Text(_currentWeather.weatherDescription.toString()),
        ],
      ),
    );
  }
}
