import 'dart:math';

import 'package:animeheart/components/animation.dart';
import 'package:flutter/material.dart';

class CircleCustomPain extends StatefulWidget {
  final int durationInSeconds;
  CircleCustomPain({required this.durationInSeconds});

  @override
  _CircleCustomPainState createState() => _CircleCustomPainState();
}

class _CircleCustomPainState extends State<CircleCustomPain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _direction = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.durationInSeconds),
      vsync: this,
    )..repeat(); // Répéter l'animation indéfiniment
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pressleft() {
    setState(() {
      _direction = 1;
    });
  }

  void _stopanime() {
    // Arrêter l'animation
    _controller.stop();
  }

  void _pressrigth() {
    setState(() {
      _direction = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(100, 100), // Taille du canevas
                    painter:
                        CircleWithNeedlePainter(_controller.value, _direction),
                    child: const Center(
                      child: HeartAnimation(),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: _pressleft,
                      tooltip: 'Increment',
                      child: Icon(Icons.arrow_left),
                    ),
                    const SizedBox(width: 30),
                    FloatingActionButton(
                      onPressed: _stopanime,
                      tooltip: 'Increment',
                      child: Icon(Icons.stop),
                    ),
                    const SizedBox(width: 30),
                    FloatingActionButton(
                      onPressed: _pressrigth,
                      tooltip: 'Increment',
                      child: const Icon(Icons.arrow_right_alt),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CircleWithNeedlePainter extends CustomPainter {
  final double progress;
  final int direction;

  CircleWithNeedlePainter(this.progress, this.direction);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Épaisseur du cercle

    // Épaisseur de l'aiguille
    Paint needlePaint = Paint()
      ..color = direction == 1 ? Colors.red : Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    double startAngle;
    if (direction == 1) {
      // Début de l'aiguille (en haut) avec l'angle en fonction du progrès
      startAngle = -pi / 2 + 2 * pi * progress;
    } else {
      startAngle = -pi / 2 - 2 * pi * progress;
    }

    // Longueur de l'aiguille (par exemple, 12 degrés)
    double sweepAngle = pi / 30;

    // Rayon du cercle ajusté pour tenir compte de l'épaisseur
    double radius = size.width / 2 - 10;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Dessiner le cercle
    canvas.drawCircle(center, radius, circlePaint);

    // Dessiner l'aiguille (arc partiel)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      needlePaint,
    );
  }

  @override
  bool shouldRepaint(CircleWithNeedlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
