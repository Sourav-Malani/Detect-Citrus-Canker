import 'package:flutter/material.dart';

import '../../controllers/weather_controller.dart';

class HourlyWeather extends StatelessWidget {
  final WeatherController wc;

  const HourlyWeather({
    Key? key,
    required this.wc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hourlyWeather();
  }

  Widget hourlyWeather() {
    return Container(
      // color: Colors.pink,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // color: Colors.pink,
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 52,
            child: Column(
              children: [
                Text(
                  wc.dateFormatHourMeridiem(wc
                      .convertToCurrentTimeZone(wc.hourlyWeather[index]['dt'])),
                  style: Theme.of(context).textTheme.caption,
                ),
                Image.network(
                  "http://openweathermap.org/img/wn/" +
                      wc.hourlyWeather[index]["weather"][0]['icon'].toString() +
                      ".png",
                  fit: BoxFit.fitHeight,
                ),
                Text(
                  "${wc.hourlyWeather[index]['temp'].toInt()}°",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // color: Colors.pink,
                      height: 12,
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.water_drop_outlined,
                        size: 8,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      "${(wc.hourlyWeather[index]['pop'] * 100).toInt()}%",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
