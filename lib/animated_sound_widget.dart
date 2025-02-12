import 'dart:math' show pi;
import 'package:flutter/material.dart';

part 'sound_controller.dart';
part 'blob.dart';

/// A widget that animates in response to sound input, creating a dynamic
/// visual effect with rotating color blobs and scaling transformations.
class AnimatedSoundWidget extends StatefulWidget {
  /// Controls the animation based on sound input.
  final SoundController soundController;

  /// Custom colors for the animated blobs. Defaults to red, green, and blue.
  final List<Color>? blobColors;

  /// A child widget (e.g., an icon) placed at the center of the animation.
  final Widget? child;

  /// The minimum and maximum size of the widget.
  final double minWidth, maxWidth, minHeight, maxHeight;

  /// The primary color used for the widget.
  final MaterialColor color;

  /// Whether to use a gradient effect instead of a solid color.
  final bool gradient;

  /// Creates an animated sound visualization widget.
  const AnimatedSoundWidget({
    super.key,
    required this.soundController,
    this.blobColors,
    this.child,
    this.color = Colors.amber,
    this.gradient = true,
    this.minWidth = 48.0,
    this.maxWidth = 80.0,
    this.minHeight = 48.0,
    this.maxHeight = 80.0,
  });

  @override
  _AnimatedSoundWidgetState createState() => _AnimatedSoundWidgetState();
}

class _AnimatedSoundWidgetState extends State<AnimatedSoundWidget>
    with TickerProviderStateMixin {
  /// Duration for the scale animation.
  static const _kScaleDuration = Duration(milliseconds: 300);

  /// Duration for the continuous rotation animation.
  static const _kRotationDuration = Duration(seconds: 5);

  late AnimationController _rotationController;
  late AnimationController _scaleController;

  double _rotation = 0;
  double _scale = 0.85;
  late List<Color> _blobColors;

  /// Determines if waves should be displayed based on animation state.
  bool get _showWaves => !_scaleController.isDismissed;

  /// Updates the rotation value based on the animation progress.
  void _updateRotation() => setState(() {
        _rotation = (_rotationController.value * 2) * pi;
      });

  /// Updates the scale value based on the animation progress.
  void _updateScale() => setState(() {
        _scale = _scaleController.value != 0
            ? (_scaleController.value * 0.2) + 0.85
            : 0.0;
      });

  @override
  void initState() {
    super.initState();

    // Set blob colors or fallback to default
    _blobColors = widget.blobColors ?? [Colors.red, Colors.green, Colors.blue];

    // Initialize rotation animation controller
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(_updateRotation)
          ..repeat();

    // Initialize scale animation controller
    _scaleController =
        AnimationController(vsync: this, duration: _kScaleDuration)
          ..addListener(_updateScale);

    // Listen for sound controller changes
    widget.soundController.addListener(_scaleListener);
  }

  /// Adjusts the scale animation based on sound intensity.
  void _scaleListener() {
    _scaleController.animateTo(widget.soundController.value);
  }

  @override
  void dispose() {
    // Remove the sound controller listener and dispose animations
    widget.soundController.removeListener(_scaleListener);
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth,
        minHeight: widget.minHeight,
        maxWidth: widget.maxWidth,
        maxHeight: widget.maxHeight,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated wave blobs
          if (_showWaves) ...[
            _Blob(color: _blobColors[0], scale: _scale, rotation: _rotation),
            _Blob(
                color: _blobColors[1],
                scale: _scale,
                rotation: _rotation * 2 - 30),
            _Blob(
                color: _blobColors[2],
                scale: _scale,
                rotation: _rotation * 3 - 45),
          ],
          // Central animated container
          Container(
            constraints: const BoxConstraints.expand(),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: widget.gradient ? null : widget.color,
              shape: BoxShape.circle,
              gradient: widget.gradient
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color.shade300,
                        widget.color.shade600,
                        widget.color.shade900,
                      ],
                    )
                  : null,
            ),
            child: widget.child ?? const Icon(Icons.mic),
          ),
        ],
      ),
    );
  }
}
