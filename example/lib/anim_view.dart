import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_bg.dart';
import 'package:flutter_weather_bg_granasoft/utils/weather_type.dart';

class AnimViewWidget extends StatefulWidget {
  @override
  _AnimViewWidgetState createState() => _AnimViewWidgetState();
}

class _AnimViewWidgetState extends State<AnimViewWidget> {
  WeatherType _weatherType = WeatherType.sunny;
  double _width = 100;
  double _height = 200;

  @override
  Widget build(BuildContext context) {
    var radius = 5 + (_width - 100) / 200 * 10;

    return Scaffold(
      appBar: AppBar(
        title: Text("AnimView"),
        actions: [
          PopupMenuButton<WeatherType>(
            itemBuilder: (context) {
              return <PopupMenuEntry<WeatherType>>[
                ...WeatherType.values
                    .map((e) => PopupMenuItem<WeatherType>(
                          value: e,
                          child: Text("${WeatherUtil.getWeatherDesc(e)}"),
                        ))
                    .toList(),
              ];
            },
            initialValue: _weatherType,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${WeatherUtil.getWeatherDesc(_weatherType)}"),
                Icon(Icons.more_vert)
              ],
            ),
            onSelected: (count) {
              setState(() {
                _weatherType = count;
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 7,
              margin: EdgeInsets.only(top: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius))),
                child: Container(
                  child: WeatherBg(
                    weatherType: _weatherType,
                    width: _width,
                    height: _height,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Slider(
              min: 100,
              max: 300,
              label: "$_width",
              divisions: 200,
              onChanged: (value) {
                setState(() {
                  _width = value;
                });
              },
              value: _width,
            ),
            SizedBox(
              height: 20,
            ),
            Slider(
              min: 200,
              max: 600,
              label: "$_height",
              divisions: 400,
              onChanged: (value) {
                setState(() {
                  _height = value;
                });
              },
              value: _height,
            )
          ],
        ),
      ),
    );
  }
}
