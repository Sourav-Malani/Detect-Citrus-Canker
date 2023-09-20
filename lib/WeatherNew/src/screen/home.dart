// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:canker_detect/WeatherNew/src/controllers/recent_search_controller.dart';

import 'package:canker_detect/WeatherNew/src/screen/search_screen.dart';
import 'package:canker_detect/WeatherNew/src/screen/widgets/app_footer.dart';
import 'package:canker_detect/WeatherNew/src/screen/widgets/current_weather.dart';
import 'package:canker_detect/WeatherNew/src/screen/widgets/dialy_weather.dart';
import 'package:canker_detect/WeatherNew/src/screen/widgets/micesllaneous_weather.dart';

import '../controllers/theme_controller.dart';
import '../controllers/weather_controller.dart';

class Home extends StatefulWidget {
  final ThemeController themeController;

  Home(
    this.themeController, {
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RecentSearchController _recentSearchController =
      RecentSearchController();
  late final WeatherController _weatherController;
  ThemeController get _themeController => widget.themeController;

  @override
  void initState() {
    _weatherController = WeatherController(_themeController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Image(
            image: _themeController.backgroundSelector(),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            alignment: _themeController.backgroundShift(),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    citySearch();
                  },
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.6,
                titlePadding: EdgeInsets.all(18),
                title: Text(
                  'Weather Page',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            body: StreamBuilder(
              stream: _weatherController.stream,
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                    return messageBox(
                      context,
                      "No Internet Connection",
                      "try agian later",
                    );
                  default:
                    messageBox(
                      context,
                      "Something is wrong",
                      "",
                    );
                }

                if (snapshot.hasError) {
                  return messageBox(
                    context,
                    '"${_weatherController.cityName}" not found',
                    'Try searching for a city name',
                  );
                } else if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return weatherCards(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  SizedBox messageBox(BuildContext context, String title, String subtitle) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.3,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            subtitle,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }

  void citySearch() async {
    String? cityName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          themeController: _themeController,
          weatherController: _weatherController,
        ),
      ),
    );

    if (cityName != null) {
      setState(() {
        // var date = int.parse(DateFormat(DateFormat.HOUR24)
        //     .format(_weatherController.getPSTTime()));
        _weatherController.setCity(cityName);
        // _themeController.setTimeNow(date);
      });
    }
  }

  SingleChildScrollView weatherCards(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CurrentWeather(wc: _weatherController),
            DailyWeather(wc: _weatherController),
            MiscellaneousWeather(wc: _weatherController, context: context),
            AppFooter(),
          ],
        ),
      ),
    );
  }

  SizedBox appHeadline(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Weather",
          style: Theme.of(context).textTheme.headline2,
          // textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
