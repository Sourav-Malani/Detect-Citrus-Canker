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
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the mobile home screen when the back button is pressed
        Navigator.pushReplacementNamed(context, '/mobileScreenLayout');
        return true; // Return true to prevent the default back button behavior
      },
      child: SafeArea(
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
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/mobileScreenLayout');
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Theme.of(context).primaryColor,                    ),
                    onPressed: () {
                      citySearch();
                    },
                  ),
                ],
                backgroundColor: Colors.green,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.6,

                  titlePadding: EdgeInsets.all(14),
                  title: Text(
                    '     Weather Page',
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
                        "try again later",
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
        _weatherController.setCity(cityName);
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
        ),
      ),
    );
  }
}
