import 'dart:ui' as UI;

import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:floating_bubbles/src/bubble_floating_animation.dart';
import 'package:flutter/material.dart';
import 'package:sa4_migration_kit/multi_tween/multi_tween.dart';

class BubblePainter extends CustomPainter {
  /// List of all bubbles in the screen at a given time.
  final List<BubbleFloatingAnimation> bubbles;

  /// Size factor of the bubble.
  final double sizeFactor;

  /// Opacity of the bubbles.
  final int opacity;

  ///Painting Style of the bubbles.
  final PaintingStyle paintingStyle;

  /// Stroke Width of the bubbles. This value is effective only if [Painting Style]
  /// is set to [PaintingStyle.stroke].
  final double strokeWidth;

  /// Shape of the Bubble.
  final BubbleShape shape;

  final UI.Image? image;

  /// This Class paints the bubble in the screen.
  ///
  /// All Fields are Required.
  BubblePainter({
    required this.bubbles,
    required this.sizeFactor,
    required this.opacity,
    required this.paintingStyle,
    required this.strokeWidth,
    required this.shape,
    this.image,
  });

  /// Painting the bubbles in the screen.
  @override
  void paint(Canvas canvas, Size size) {
    bubbles.forEach((particle) {
      final paint = Paint()
        ..color = particle.color.withAlpha(opacity)
        ..style = paintingStyle
        ..strokeWidth = strokeWidth; //can be from 5 to 15.
      final progress = particle.progress();
      final MultiTweenValues animation = particle.tween.transform(progress);
      final position = Offset(
        animation.get<double>(OffsetProps.x) * size.width,
        animation.get<double>(OffsetProps.y) * size.height,
      );

      if (shape == BubbleShape.circle)
        canvas.drawCircle(
          position,
          size.width * sizeFactor * particle.size,
          paint,
        );
      else if (shape == BubbleShape.square)
        canvas.drawRect(
            Rect.fromCircle(
              center: position,
              radius: size.width * sizeFactor * particle.size,
            ),
            paint);
      else if (shape == BubbleShape.image) {
        // get image from assets named bubble.png
        if (image == null) return;

        canvas.drawImage(
          image!,
          Offset(
            position.dx - size.width * sizeFactor * particle.size / 2,
            position.dy - size.height * sizeFactor * particle.size / 2,
          ),
          paint,
        );
      } else {
        Rect rect() => Rect.fromCircle(
              center: position,
              radius: size.width * sizeFactor * particle.size,
            );
        canvas.drawRRect(
            RRect.fromRectAndRadius(
              rect(),
              Radius.circular(size.width * sizeFactor * particle.size * 0.5),
            ),
            paint);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
