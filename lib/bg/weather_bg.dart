import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_cloud_bg.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_color_bg.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_night_star_bg.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_rain_snow_bg.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_thunder_bg.dart';
import 'package:flutter_weather_bg_granasoft/utils/weather_type.dart';

class WeatherBg extends StatefulWidget {
  final WeatherType weatherType;
  final double width;
  final double height;

  WeatherBg(
      {Key? key,
      required this.weatherType,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  _WeatherBgState createState() => _WeatherBgState();
}

class _WeatherBgState extends State<WeatherBg>
    with SingleTickerProviderStateMixin {
  WeatherType? _oldWeatherType;
  bool needChange = false;
  var state = CrossFadeState.showSecond;

  @override
  void didUpdateWidget(WeatherBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weatherType != oldWidget.weatherType) {
      _oldWeatherType = oldWidget.weatherType;
      needChange = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var oldBgWidget;
    if (_oldWeatherType != null) {
      oldBgWidget = WeatherItemBg(
        weatherType: _oldWeatherType!,
        width: widget.width,
        height: widget.height,
      );
    }
    var currentBgWidget = WeatherItemBg(
      weatherType: widget.weatherType,
      width: widget.width,
      height: widget.height,
    );
    if (oldBgWidget == null) {
      oldBgWidget = currentBgWidget;
    }
    var firstWidget = currentBgWidget;
    var secondWidget = currentBgWidget;
    if (needChange) {
      if (state == CrossFadeState.showSecond) {
        state = CrossFadeState.showFirst;
        firstWidget = currentBgWidget;
        secondWidget = oldBgWidget;
      } else {
        state = CrossFadeState.showSecond;
        secondWidget = currentBgWidget;
        firstWidget = oldBgWidget;
      }
    }
    needChange = false;
    return SizeInherited(
      child: AnimatedCrossFade(
        firstChild: firstWidget,
        secondChild: secondWidget,
        duration: Duration(milliseconds: 300),
        crossFadeState: state,
      ),
      size: Size(widget.width, widget.height),
    );
  }
}

class WeatherItemBg extends StatelessWidget {
  final WeatherType weatherType;
  final width;
  final height;

  WeatherItemBg({Key? key, required this.weatherType, this.width, this.height})
      : super(key: key);

  Widget _buildNightStarBg() {
    if (weatherType == WeatherType.sunnyNight) {
      return WeatherNightStarBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  Widget _buildThunderBg() {
    if (weatherType == WeatherType.thunder) {
      return WeatherThunderBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  Widget _buildRainSnowBg() {
    if (WeatherUtil.isSnowRain(weatherType)) {
      return WeatherRainSnowBg(
        weatherType: weatherType,
        viewWidth: width,
        viewHeight: height,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            WeatherColorBg(weatherType: weatherType,),
            WeatherCloudBg(
              weatherType: weatherType,
            ),
            _buildRainSnowBg(),
            _buildThunderBg(),
            _buildNightStarBg(),
          ],
        ),
      ),
    );
  }
}

class SizeInherited extends InheritedWidget {
  final Size size;

  const SizeInherited({
    Key? key,
    required Widget child,
    required this.size,
  }) : super(key: key, child: child);

  static SizeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeInherited>();
  }

  @override
  bool updateShouldNotify(SizeInherited old) {
    return old.size != size;
  }
}
