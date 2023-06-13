import 'package:canker_detect/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import'package:canker_detect/WeatherModel/weather_data_hourly.dart';
import 'package:canker_detect/Controller/controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get/state_manager.dart';

class HourlyDataWidget extends StatelessWidget {
  final WeatherDataHourly weatherDataHourly;
   HourlyDataWidget({Key? key, required this.weatherDataHourly})
  :super(key:key);

  //card index
 RxInt cardIndex= GlobalController(). getIndex();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin:const EdgeInsets.symmetric(vertical: 5 ,horizontal: 20),
          alignment: Alignment.topCenter,
          child:const Text("Today",style: TextStyle(fontSize: 18)),
          

        ),
        hourlyList(),
      ],
    );
  }
  Widget hourlyList(){
    return Container(
      height:160,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child:ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:weatherDataHourly.hourly.length > 12 
        ? 14 //time values to show cards
        : weatherDataHourly.hourly.length,
        itemBuilder: (context,index){
          return Obx((()=>GestureDetector(
            onTap:(){
              cardIndex.value=index;
            } ,
            child: Container(
              width:90,
              margin: const EdgeInsets.only(left:20,right:5),
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(offset: const Offset(0.5, 0),
               blurRadius: 30, 
               spreadRadius: 1,
                color: CustomColors.dividerLine.withAlpha(150))
            ],
            gradient: cardIndex.value==index 
            ? const LinearGradient(colors:[
              CustomColors.firstGradientColor,
                CustomColors.secondGradientColor,
            ] )
            :null
           ), 
           child: HourlyDetails(
            temp: weatherDataHourly.hourly[index].temp!,
            index: index,
            cardIndex: cardIndex.toInt(),
            timeStamp: weatherDataHourly.hourly[index].dt!,
            weatherIcon: 
            weatherDataHourly.hourly[index].weather![0].icon!,
           ) ,
          ))));
        },
        ),
    );
  }

}

//hourly details class

class HourlyDetails extends StatelessWidget{
  int temp;
  int index;
  int cardIndex;
  int timeStamp;
  String weatherIcon;

  String getTime(final timeStamp){
    DateTime time =DateTime.fromMillisecondsSinceEpoch(timeStamp*1000);
    String x= DateFormat('jm').format(time);
    return x;
  }

  HourlyDetails({Key?key,
  required this.timeStamp,
  required this.index,
  required this.cardIndex,
  required this.temp,
  required this.weatherIcon})
  :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(top:10),
          child: Text(getTime(timeStamp),
          style:TextStyle(
           color: cardIndex == index 
           ? Colors.white
           :CustomColors.textColorBlack,
           )),
        ),
        Container(
         child: Image.asset("assets/weather/$weatherIcon.png",
         height:40,
         width: 40,) 
        ),
        Container(
          margin: const EdgeInsets.only(bottom:10),
          child: Text("$temp°C",
          style:TextStyle(
            color: cardIndex == index 
           ? Colors.white
           :CustomColors.textColorBlack,)),

        )
      ],
    );
  }
}