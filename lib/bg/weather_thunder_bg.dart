import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_granasoft/bg/weather_bg.dart';
import 'package:flutter_weather_bg_granasoft/utils/image_utils.dart';
import 'package:flutter_weather_bg_granasoft/utils/weather_type.dart';

class WeatherThunderBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherThunderBg({Key? key, required this.weatherType}) : super(key: key);

  @override
  _WeatherCloudBgState createState() => _WeatherCloudBgState();
}

class _WeatherCloudBgState extends State<WeatherThunderBg>
    with SingleTickerProviderStateMixin {
  List<ui.Image> _images = [];
  late AnimationController _controller;
  List<ThunderParams> _thunderParams = [];
  WeatherDataState? _state;

  Future<void> fetchImages() async {
    var image1 = await ImageUtils.getImage('images/lightning0.webp');
    var image2 = await ImageUtils.getImage('images/lightning1.webp');
    var image3 = await ImageUtils.getImage('images/lightning2.webp');
    var image4 = await ImageUtils.getImage('images/lightning3.webp');
    var image5 = await ImageUtils.getImage('images/lightning4.webp');
    _images.add(image1);
    _images.add(image2);
    _images.add(image3);
    _images.add(image4);
    _images.add(image5);
    _state = WeatherDataState.init;
    setState(() {});
  }

  @override
  void initState() {
    fetchImages();
    initAnim();
    super.initState();
  }

  void initAnim() {
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        Future.delayed(Duration(milliseconds: 50)).then((value) {
          initThunderParams();
          _controller.forward();
        });
      }
    });

    var _animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0,
        0.3,
        curve: Curves.ease,
      ),
    ));

    var _animation1 = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.2,
        0.5,
        curve: Curves.ease,
      ),
    ));

    var _animation2 = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 3),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.6,
        0.9,
        curve: Curves.ease,
      ),
    ));

    _animation.addListener(() {
      if (_thunderParams.isNotEmpty) {
        _thunderParams[0].alpha = _animation.value;
      }
      setState(() {});
    });

    _animation1.addListener(() {
      if (_thunderParams.isNotEmpty) {
        _thunderParams[1].alpha = _animation1.value;
      }
      setState(() {});
    });

    _animation2.addListener(() {
      if (_thunderParams.isNotEmpty) {
        _thunderParams[2].alpha = _animation2.value;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    if (_thunderParams.isNotEmpty &&
        widget.weatherType == WeatherType.thunder) {
      return CustomPaint(
        painter: ThunderPainter(_thunderParams),
      );
    } else {
      return Container();
    }
  }

  void initThunderParams() {
    _state = WeatherDataState.loading;
    _thunderParams.clear();
    var size = SizeInherited.of(context)?.size;
    var width = size?.width ?? double.infinity;
    var height = size?.height ?? double.infinity;
    var widthRatio = width / 392.0;
    for (var i = 0; i < 3; i++) {
      var param = ThunderParams(
          _images[Random().nextInt(5)], width, height, widthRatio);
      param.reset();
      _thunderParams.add(param);
    }
    _controller.forward();
    _state = WeatherDataState.finish;
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      initThunderParams();
    } else if (_state == WeatherDataState.finish) {
      return _buildWidget();
    }
    return Container();
  }
}

class ThunderPainter extends CustomPainter {
  var _paint = Paint();
  final List<ThunderParams> thunderParams;

  ThunderPainter(this.thunderParams);

  @override
  void paint(Canvas canvas, Size size) {
    if (thunderParams.isNotEmpty) {
      for (var param in thunderParams) {
        drawThunder(param, canvas, size);
      }
    }
  }

  void drawThunder(ThunderParams params, Canvas canvas, Size size) {
    canvas.save();
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
      params.alpha,
      0,
    ]);
    _paint.colorFilter = identity;
    canvas.scale(params.widthRatio * 1.2);
    canvas.drawImage(params.image, Offset(params.x, params.y), _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ThunderParams {
  late ui.Image image;
  late double x;
  late double y;
  late double alpha;
  int get imgWidth => image.width;
  int get imgHeight => image.height;
  final double width, height, widthRatio;

  ThunderParams(this.image, this.width, this.height, this.widthRatio);

  void reset() {
    x = Random().nextDouble() * 0.5 * widthRatio - 1 / 3 * imgWidth;
    y = Random().nextDouble() * -0.05 * height;
    alpha = 0;
  }
}
