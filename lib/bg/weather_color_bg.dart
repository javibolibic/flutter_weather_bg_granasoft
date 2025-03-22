import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_granasoft/utils/weather_type.dart';

class WeatherColorBg extends StatelessWidget {
  final WeatherType weatherType;

  final double? height;

  WeatherColorBg({Key? key, required this.weatherType, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: WeatherUtil.getColor(weatherType),
        stops: [0, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
    );
  }
}
