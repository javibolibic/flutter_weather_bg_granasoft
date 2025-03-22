import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_bg.dart';
import 'package:flutter_weather_bg_granasoft/utils/weather_type.dart';

class PageViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PageView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                WeatherBg(
                  weatherType: WeatherType.values[index],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Center(
                  child: Text(
                    WeatherUtil.getWeatherDesc(WeatherType.values[index]),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            );
          },
          itemCount: WeatherType.values.length,
        ),
      ),
    );
  }
}
