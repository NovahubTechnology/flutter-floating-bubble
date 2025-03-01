import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';

import 'fps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: true,
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

// Simple example.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    eachFrame()
        .take(10000)
        .transform(const ComputeFps())
        // ignore: avoid_print
        .listen((fps) => print('fps: $fps'));
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
              // color: Colors.blue,
              ),
        ),
        Positioned.fill(
          child: FloatingBubbles.alwaysRepeating(
            noOfBubbles: 20,
            colorsOfBubbles: const [
              Colors.white,
              Colors.red,
            ],
            sizeFactor: 0.3,
            opacity: 200,
            speed: BubbleSpeed.slow,
            paintingStyle: PaintingStyle.stroke,
            shape: BubbleShape.image,
            imagePath: 'assets/ic_heart.png',
          ),
        ),
      ],
    );
  }
}
