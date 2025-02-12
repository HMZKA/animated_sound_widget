# AnimatedSoundWidget

A Flutter widget that animates in response to sound input, creating a dynamic visual effect with rotating color blobs and scaling transformations. It reacts to the intensity of the sound and visualizes it using smooth animations.
<p align="left">
  <img src="https://github.com/HMZKA/animated_sound_widget/blob/main/images/screenshot.gif" alt="Enabled State" width="200"/>
</p>

## Features
- Animated blobs that respond to sound intensity.
- Continuous rotation animation.
- Customizable colors and gradient effects.
- Supports adding a child widget (e.g., an icon or image).
- Adjustable size constraints.

## Installation

To install the package, run the following command:
```
flutter pub add animated_sound_widget
```

Add this widget to your project by copying the source files into your Flutter application.

## Usage

### Import the package
```dart
import 'package:flutter/material.dart';
import 'animated_sound_widget.dart';
```

### Example Usage
```dart
import 'package:flutter/material.dart';
import 'animated_sound_widget.dart';
import 'sound_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SoundController _soundController;

  @override
  void initState() {
    super.initState();
    _soundController = SoundController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AnimatedSoundWidget(
            soundController: _soundController,
            blobColors: [Colors.purple, Colors.orange, Colors.blue],
            child: const Icon(Icons.mic, color: Colors.white, size: 40),
            minWidth: 50,
            maxWidth: 100,
            minHeight: 50,
            maxHeight: 100,
            color: Colors.teal,
            gradient: true,
          ),
        ),
      ),
    );
  }
}
```

## Parameters

| Parameter         | Type          | Description |
|------------------|--------------|-------------|
| `soundController` | `SoundController` | Controls the animation based on sound intensity. The `value` of `soundController` should be between `0` and `1`. |
| `blobColors` | `List<Color>?` | Custom colors for the animated blobs. Defaults to `[Colors.red, Colors.green, Colors.blue]`. |
| `child` | `Widget?` | A widget (e.g., an icon) placed at the center of the animation. |
| `minWidth` | `double` | The minimum width of the widget. Default is `48.0`. |
| `maxWidth` | `double` | The maximum width of the widget. Default is `80.0`. |
| `minHeight` | `double` | The minimum height of the widget. Default is `48.0`. |
| `maxHeight` | `double` | The maximum height of the widget. Default is `80.0`. |
| `color` | `MaterialColor` | The primary color used for the widget. Default is `Colors.amber`. |
| `gradient` | `bool` | Whether to use a gradient effect instead of a solid color. Default is `true`. |

## How It Works
- The widget uses an `AnimationController` to rotate the blobs continuously.
- Another `AnimationController` listens to the `soundController` value (ranging from `0` to `1`) and scales the blobs accordingly.
- The blobs rotate and expand based on the sound intensity.
- A central container (with an optional child) remains in the middle, with a gradient or solid color background.

## Customization
You can customize the appearance of the widget by modifying:
- `blobColors`: Change the colors of the animated blobs.
- `color`: Change the primary color of the widget.
- `gradient`: Toggle between a solid color or gradient effect.
- `child`: Replace the default microphone icon with any widget.

## SoundController
The `SoundController` should be implemented in a way that it provides values between `0` and `1`, representing the intensity of the detected sound.
You can update `soundController.value` based on microphone input or other sound intensity sources.

## License
This widget is open-source. Feel free to modify and use it in your projects!

---

