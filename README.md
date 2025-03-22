# flutter_weather_bg_granasoft
https://github.com/javibolibic/flutter_weather_bg_granasoft


A rich and cool weather dynamic background plug-in, supporting 16 weather types.


## Features 

- It supports 16 weather types: sunny, sunny evening, few clouds, cloudy, cloudy evening, overcast, small to medium heavy rain, small to medium heavy snow, fog, haze, floating dust and thunderstorm
- Support dynamic scale size, adapt to multi scene display
- Supports over animation when switching weather types

## Supported platforms 

- Flutter Android
- Flutter iOS
- Flutter web
- Flutter desktop

## Installation

Add  `flutter_weather_bg_null_safety: ^1.0.0` to your `pubspec.yaml` dependencies. And import it:

```dar
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
```

## How to use 

To configure the weather type by creating `WeatherBg`, you need to pass in the width and height to complete the final display

```dart
WeatherBg(weatherType: _weatherType,width: _width,height: _height,)
```



## License 

MIT