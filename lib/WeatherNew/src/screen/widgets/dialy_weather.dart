import 'package:flutter/material.dart';

import '../../controllers/weather_controller.dart';
import '../../model/string_extension.dart';

class DailyWeather extends StatelessWidget {
  final WeatherController wc;
  const DailyWeather({
    Key? key,
    required this.wc,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return dailyWeather();
  }

  Widget dailyWeather() {
    return SizedBox(
      height: 332,
      // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wc.dailyWeather.length,
            itemBuilder: ((context, index) {
              return Row(
                children: [
                  SizedBox(
                    width: 65,
                    child: Text(
                      wc.dateFormatWeek(
                        wc.dailyWeather[index]['dt'],
                        index,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
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
                              "${(wc.dailyWeather[index]['pop'] * 100).toInt()}%",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        SizedBox(
                          // color: Colors.pink,
                          height: 38,
                          child: Image.network(
                            "http://openweathermap.org/img/wn/" +
                                wc.dailyWeather[index]["weather"][0]['icon']
                                    .toString() +
                                ".png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        // Text(_dailyWeather[index]["weather"][0]['main']),
                        Text(
                          wc.temperatureTrim(
                                  '${wc.dailyWeather[index]['temp']['max'].toInt()}°') +
                              "/" +
                              wc.temperatureTrim(
                                  '${wc.dailyWeather[index]['temp']['min'].toInt()}°'),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    // color: Colors.pink,
                    width: 90,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        wc.dailyWeather[index]["weather"][0]['description']
                            .toString()
                            .capitalize(),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
