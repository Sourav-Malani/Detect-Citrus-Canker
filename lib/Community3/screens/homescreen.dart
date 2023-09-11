import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:canker_detect/constants.dart';

class ProductCardWidget extends StatefulWidget {
  @override
  _ProductCardWidgetState createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  int currentPage = 0;
  final List<Map<String, String>> imagesData = [
    {
      'title': "Onboarding-titleOne".tr(),
      'description': "Onboarding-titleOneDesc".tr(),
      'imagePath': 'assets/images/community.png',
    },
    {
      'title': "Onboarding-titleTwo".tr(),
      'description': "Onboarding-titleTwoDesc".tr(),
      'imagePath': 'assets/images/plant_two.png',
    },
    {
      'title': "Onboarding-titleThree".tr(),
      'description': "Onboarding-titleThreeDesc".tr(),
      'imagePath': 'assets/images/weather.png',
    },
  ];

  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (currentPage < imagesData.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 1.0),
              colors: <Color>[
                Color(0xFF4BA198),
                Color(0xFF4BA198),
              ],
              stops: <double>[0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Instructions",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: imagesData.length,
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildImageCard(imagesData[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Features",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildCard(
                    context,
                    'Detect Canker',
                    'assets/images/card1.png',
                    Colors.orange,
                  ),
                  const SizedBox(height: 20.0),
                  _buildCard(
                    context,
                    'Check Weather',
                    'assets/images/card2.png',
                    Colors.blue.shade200,
                  ),
                  const SizedBox(height: 20.0),
                  _buildCard(
                    context,
                    'Community',
                    'assets/images/card3.png',
                    Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(Map<String, String> imageData) {
    final title = imageData['title'] ?? '';
    final description = imageData['description'] ?? '';
    final imagePath = imageData['imagePath'] ?? '';

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Image.asset(
              imagePath,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String imagePath,
    Color color,
  ) {
    String route = '';
    if (title == 'Detect Canker') {
      route = "/CankerDetect";
    } else if (title == 'Check Weather') {
      route = "/weatherPage";
    } else if (title == 'Community') {
      route = "/feedScreen";
    }

    return InkWell(
      onTap: () {
        // ignore: unnecessary_null_comparison
        if (route != null) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        height: 150,
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      imagePath,
                      height: 80,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
