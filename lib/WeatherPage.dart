import 'package:canker_detect/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller/controller.dart';
import 'Widgets/header_widget.dart';
import 'Widgets/current_weather_widget.dart';
import 'Widgets/hourly_data_widget.dart';
import 'Widgets/daily_data_forecast.dart';
import 'Widgets/comfort_level.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to the home screen when the back button is pressed
        Navigator.pushReplacementNamed(context, '/mobileScreenLayout');
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        body: SafeArea(
          child: Obx(() => globalController.checkLoading().isTrue
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icon/icon.png",
                      height: 200,
                      width: 200,
                    ),
                    const CircularProgressIndicator()
                  ],
                ))
              : Center(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const HeaderWidget(),
                      //for our current temp ('current')
                      CurrentWeatherWidget(
                        weatherDataCurrent:
                            globalController.getData().getCurrentWeather(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Hourly Data Widget
                      HourlyDataWidget(
                          weatherDataHourly:
                              globalController.getData().getHourlyWeather()),
                      //Daily Data widget
                      DailyDataForecast(
                        weatherDataDaily:
                            globalController.getData().getDailyWeather(),
                      ),
                      Container(
                        height: 1,
                        color: CustomColors.dividerLine,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ComfortLevel(
                          weatherDataCurrent:
                              globalController.getData().getCurrentWeather())
                    ],
                  ),
                )),
        ),
      ),
    );
  }
}
