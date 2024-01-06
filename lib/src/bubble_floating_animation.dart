import 'dart:math';

import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:sa4_migration_kit/sa4_migration_kit.dart';

enum OffsetProps { x, y }

/// This class Creates the animation of the bubbles flowing from bottom to top in the screen.
class BubbleFloatingAnimation {
  /// Creates a tween between x and y coordinates.
  late MultiTween<OffsetProps> tween;

  /// Size of the bubble
  late double size;

  ///Duration of each bubble to reach to top from bottom.
  late Duration duration;

  /// Start Time duration of each bubble.
  late Duration startTime;

  /// Random object.
  final Random random;

  /// Color of the bubble
  final Color color;

  /// Speed of the bubble
  final BubbleSpeed speed;

  BubbleFloatingAnimation(this.random,
      {required this.color, required this.speed}) {
    _restart();
    _shuffle();
  }

  /// Function to Restart the floating bubble animation.
  _restart() {
    final startPosition = Offset(
      -0.2 + 1.4 * random.nextDouble(),
      1.2,
    );
    final endPosition = Offset(
      -0.2 + 1.4 * random.nextDouble(),
      -0.2,
    );

    tween = MultiTween<OffsetProps>()
      ..add(
        OffsetProps.x,
        Tween(
          begin: startPosition.dx,
          end: endPosition.dx,
        ),
      )
      ..add(
        OffsetProps.y,
        Tween(
          begin: startPosition.dy,
          end: endPosition.dy,
        ),
      );

    duration = Duration(
          milliseconds: speed == BubbleSpeed.fast
              ? 1500
              : speed == BubbleSpeed.normal
                  ? 4500
                  : 9000,
        ) +
        Duration(
          milliseconds: random.nextInt(
            speed == BubbleSpeed.fast
                ? 3000
                : speed == BubbleSpeed.normal
                    ? 9000
                    : 18000,
          ),
        );

    startTime = Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch,
    );

    /// Size of each Bubble is calculated through this.
    size = 0.2 + random.nextDouble() * 0.4;
  }

  /// Shuffles the position of bubbles around the screen.
  void _shuffle() {
    startTime -= Duration(
      milliseconds:
          (this.random.nextDouble() * duration.inMilliseconds).round(),
    );
  }

  /// A Function to Check if a bubble needs to be recontructed in the ui.
  checkIfBubbleNeedsToBeRestarted() {
    if (progress() == 1.0) {
      _restart();
    }
  }

  /// This Function Checks whether a bubble has reached from bottom to top.
  ///
  /// if the progress returns 1, then that bubble has reached the top.
  double progress() {
    return ((Duration(
                  milliseconds: DateTime.now().millisecondsSinceEpoch,
                ).inMicroseconds -
                startTime.inMicroseconds) /
            duration.inMicroseconds)
        .clamp(0.0, 1.0)
        .toDouble();
  }
}
