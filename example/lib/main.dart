import 'dart:async';

import 'package:animated_sound_widget/animated_sound_widget.dart';
import 'package:audio_streamer/audio_streamer.dart';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? noiseMeter;

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) => setState(() {
        _latestReading = noiseReading;
        soundController?.value = _latestReading!.meanDecibel.floor() * 0.013;
        print(soundController?.value);
      });

  void onError(Object error) {
    print(error);
    stop();
  }

  /// Check if microphone permission is granted.
  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  /// Request the microphone permission.
  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  /// Start noise sampling.
  Future<void> start() async {
    // Create a noise meter, if not already done.
    noiseMeter ??= NoiseMeter();

    // Check permission to use the microphone.
    //
    // Remember to update the AndroidManifest file (Android) and the
    // Info.plist and pod files (iOS).
    if (!(await checkPermission())) await requestPermission();

    // Listen to the noise stream.
    _noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => isRecording = true);
  }

  /// Stop sampling.
  void stop() {
    _noiseSubscription?.cancel();
    soundController?.value = 0;
    setState(() => isRecording = false);
  }

  SoundController? soundController = SoundController(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: isRecording ? Colors.red : Colors.green,
          onPressed: isRecording ? stop : start,
          child: isRecording ? Icon(Icons.stop) : Icon(Icons.mic),
        ),
        body: Center(
          child: AnimatedSoundWidget(soundController: soundController!),
        ),
      ),
    );
  }
}
