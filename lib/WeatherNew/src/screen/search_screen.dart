import 'package:flutter/material.dart';
import '../controllers/recent_search_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/weather_controller.dart';

class SearchScreen extends StatefulWidget {
  final ThemeController themeController;
  final WeatherController weatherController;

  const SearchScreen({
    Key? key,
    required this.themeController,
    required this.weatherController,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RecentSearchController _rsc = RecentSearchController();

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        Image(
          image: widget.themeController.backgroundSelector(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: widget.themeController.backgroundShift(),
        ),
        Scaffold(
            backgroundColor: Theme.of(context).cardTheme.color,
            appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () => setCity(context,
                        textEditingController: _textEditingController),
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
                // The search area here
                title: Center(
                  child: TextField(
                    autofocus: true,
                    onSubmitted: (_textEditingController) {
                      setCity(context,
                          textEditingController: this._textEditingController);
                      // Random random = Random();
                      // int randomNumber = random.nextInt(24);
                      // themeController.setTimeNow(randomNumber);
                    },
                    controller: _textEditingController,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                )),
            body: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: _rsc.searches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    setCity(context, city: _rsc.searches[index]);
                    var temp = _rsc.searches[index];
                    _rsc.searches.removeAt(index);
                    _rsc.add(temp);
                  },
                  title: Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        _rsc.searches[index],
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () => setState(() {
                            _rsc.remove(index);
                          }),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                      )),
                );
              },
            )
            // body: const Text("Hello World"),
            ),
      ],
    ));
  }

  void setCity(BuildContext context,
      {String? city, TextEditingController? textEditingController}) {
    if (textEditingController != null) {
      if (textEditingController.text.trim() == '') {
        return;
      }

      _rsc.add(textEditingController.text.trim());
      Navigator.of(context).pop(textEditingController.text.trim());
      return;
    }

    if (city?.trim() == '') {
      return;
    }
    Navigator.of(context).pop(city?.trim());
  }
}
