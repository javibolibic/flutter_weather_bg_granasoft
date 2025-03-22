import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_bg.dart';
import 'package:flutter_weather_bg_granasoft/utils/image_utils.dart';
import 'package:flutter_weather_bg_granasoft/utils/weather_type.dart';

class WeatherRainSnowBg extends StatefulWidget {
  final WeatherType weatherType;
  final double viewWidth;
  final double viewHeight;

  WeatherRainSnowBg(
      {Key? key,
      required this.weatherType,
      required this.viewWidth,
      required this.viewHeight})
      : super(key: key);

  @override
  _WeatherRainSnowBgState createState() => _WeatherRainSnowBgState();
}

class _WeatherRainSnowBgState extends State<WeatherRainSnowBg>
    with SingleTickerProviderStateMixin {
  List<ui.Image> _images = [];
  late AnimationController _controller;
  List<RainSnowParams> _rainSnows = [];
  int count = 0;
  WeatherDataState? _state;

  Future<void> fetchImages() async {
    var image1 = await ImageUtils.getImage('images/rain.webp');
    var image2 = await ImageUtils.getImage('images/snow.webp');
    _images.clear();
    _images.add(image1);
    _images.add(image2);
    _state = WeatherDataState.init;
    setState(() {});
  }

  Future<void> initParams() async {
    _state = WeatherDataState.loading;
    if (widget.viewWidth != 0 && widget.viewHeight != 0 && _rainSnows.isEmpty) {
      if (WeatherUtil.isSnowRain(widget.weatherType)) {
        if (widget.weatherType == WeatherType.lightRainy) {
          count = 70;
        } else if (widget.weatherType == WeatherType.middleRainy) {
          count = 100;
        } else if (widget.weatherType == WeatherType.heavyRainy ||
            widget.weatherType == WeatherType.thunder) {
          count = 200;
        } else if (widget.weatherType == WeatherType.lightSnow) {
          count = 30;
        } else if (widget.weatherType == WeatherType.middleSnow) {
          count = 100;
        } else if (widget.weatherType == WeatherType.heavySnow) {
          count = 200;
        }
        var size = SizeInherited.of(context)?.size;
        var width = size?.width ?? double.infinity;
        var height = size?.height ?? double.infinity;
        var widthRatio = width / 392.0;
        var heightRatio = height / 817;
        for (int i = 0; i < count; i++) {
          var rainSnow = RainSnowParams(
              widget.viewWidth, widget.viewHeight, widget.weatherType);
          rainSnow.init(widthRatio, heightRatio);
          _rainSnows.add(rainSnow);
        }
      }
    }
    _controller.forward();
    _state = WeatherDataState.finish;
  }

  @override
  void didUpdateWidget(WeatherRainSnowBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherType != widget.weatherType ||
        oldWidget.viewWidth != widget.viewWidth ||
        oldWidget.viewHeight != widget.viewHeight) {
      _rainSnows.clear();
      initParams();
    }
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(minutes: 1), vsync: this);
    CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
    fetchImages();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      initParams();
    } else if (_state == WeatherDataState.finish) {
      return CustomPaint(
        painter: RainSnowPainter(this),
      );
    }
    return Container();
  }
}

class RainSnowPainter extends CustomPainter {
  var _paint = Paint();
  _WeatherRainSnowBgState _state;

  RainSnowPainter(this._state);

  @override
  void paint(Canvas canvas, Size size) {
    if (WeatherUtil.isSnow(_state.widget.weatherType)) {
      drawSnow(canvas, size);
    } else if (WeatherUtil.isRainy(_state.widget.weatherType)) {
      drawRain(canvas, size);
    }
  }

  void drawRain(Canvas canvas, Size size) {
    if (_state._images.length > 1) {
      ui.Image image = _state._images[0];
      if (_state._rainSnows.isNotEmpty) {
        _state._rainSnows.forEach((element) {
          move(element);
          ui.Offset offset = ui.Offset(element.x, element.y);
          canvas.save();
          canvas.scale(element.scale);
          var identity = ColorFilter.matrix(<double>[
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            element.alpha,
            0,
          ]);
          _paint.colorFilter = identity;
          canvas.drawImage(image, offset, _paint);
          canvas.restore();
        });
      }
    }
  }

  void move(RainSnowParams params) {
    params.y = params.y + params.speed;
    if (WeatherUtil.isSnow(_state.widget.weatherType)) {
      double offsetX = sin(params.y / (300 + 50 * params.alpha)) *
          (1 + 0.5 * params.alpha) *
          params.widthRatio;
      params.x += offsetX;
    }
    if (params.y > params.height / params.scale) {
      params.y = -params.height * params.scale;
      if (WeatherUtil.isRainy(_state.widget.weatherType) &&
          _state._images.isNotEmpty) {
        params.y = -_state._images[0].height.toDouble();
      }
      params.reset();
    }
  }

  void drawSnow(Canvas canvas, Size size) {
    if (_state._images.length > 1) {
      ui.Image image = _state._images[1];
      if (_state._rainSnows.isNotEmpty) {
        _state._rainSnows.forEach((element) {
          move(element);
          ui.Offset offset = ui.Offset(element.x, element.y);
          canvas.save();
          canvas.scale(element.scale, element.scale);
          var identity = ColorFilter.matrix(<double>[
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            element.alpha,
            0,
          ]);
          _paint.colorFilter = identity;
          canvas.drawImage(image, offset, _paint);
          canvas.restore();
        });
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class RainSnowParams {
  late double x;

  late double y;

  late double speed;

  late double scale;

  double width;

  double height;

  late double alpha;

  WeatherType weatherType;

  late double widthRatio;
  late double heightRatio;

  RainSnowParams(this.width, this.height, this.weatherType);

  void init(widthRatio, heightRatio) {
    this.widthRatio = widthRatio;
    this.heightRatio = max(heightRatio, 0.65);

    reset();
    y = Random().nextInt(800 ~/ scale).toDouble();
  }

  void reset() {
    double ratio = 1.0;

    if (weatherType == WeatherType.lightRainy) {
      ratio = 0.5;
    } else if (weatherType == WeatherType.middleRainy) {
      ratio = 0.75;
    } else if (weatherType == WeatherType.heavyRainy ||
        weatherType == WeatherType.thunder) {
      ratio = 1;
    } else if (weatherType == WeatherType.lightSnow) {
      ratio = 0.5;
    } else if (weatherType == WeatherType.middleSnow) {
      ratio = 0.75;
    } else if (weatherType == WeatherType.heavySnow) {
      ratio = 1;
    }
    if (WeatherUtil.isRainy(weatherType)) {
      double random = 0.4 + 0.12 * Random().nextDouble() * 5;
      this.scale = random * 1.2;
      this.speed = 30 * random * ratio * heightRatio;
      this.alpha = random * 0.6;
      x = Random().nextInt(width * 1.2 ~/ scale).toDouble() -
          width * 0.1 ~/ scale;
    } else {
      double random = 0.4 + 0.12 * Random().nextDouble() * 5;
      this.scale = random * 0.8 * heightRatio;
      this.speed = 8 * random * ratio * heightRatio;
      this.alpha = random;
      x = Random().nextInt(width * 1.2 ~/ scale).toDouble() -
          width * 0.1 ~/ scale;
    }
  }
}
