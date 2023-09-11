import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:canker_detect/api/fetch_Weather.dart';
import 'package:canker_detect/WeatherModel/weather_data.dart';

class GlobalController extends GetxController {
  final RxBool _isloading = true.obs;
  final RxDouble _lattitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex= 0.obs;

  //instance for them to called
  RxBool checkLoading() => _isloading;
  RxDouble getLattitude() => _lattitude;
  RxDouble getLongitude() => _longitude;

  final weatherData= WeatherData().obs;

 WeatherData getData()
 {
  return weatherData.value;
 }

  @override
  void onInit() {
    if (_isloading.isTrue) {
      getLocation();
    }
    else
    {
      getIndex();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      return Future.error("Location not enabled");
    }
    //status of permission

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permission denied Forever");
    } else if (locationPermission == LocationPermission.denied) {
      //request permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location Permission is denied");
      }
    }
    //getting the current position
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      //update our lattitude and longitude
      _lattitude.value = value.latitude;
      _longitude.value = value.longitude;

      return FetchWeatherAPI().processData(value.latitude,value.longitude)
      .then((value){
        weatherData.value=value;
        _isloading.value=false;
      } );
      });

  }
  RxInt getIndex(){
    return _currentIndex;
  }

}
