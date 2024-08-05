import 'dart:math';

import 'package:animeheart/components/animation.dart';
import 'package:flutter/material.dart';

class CircleCustomPain extends StatefulWidget {
  @override
  _CircleCustomPainState createState() => _CircleCustomPainState();
}

class _CircleCustomPainState extends State<CircleCustomPain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Durée pour une rotation complète
      vsync: this,
    )..repeat(); // Répéter l'animation indéfiniment
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(100, 100), // Taille du canevas
            painter: CircleWithNeedlePainter(_controller.value),
            child: const Center(
              child: HeartAnimation(),
            ),
          );
        },
      ),
    );
  }
}

class CircleWithNeedlePainter extends CustomPainter {
  final double progress;

  CircleWithNeedlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Épaisseur du cercle

    Paint needlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20; // Épaisseur de l'aiguille

    double radius = size.width / 2 -
        10; // Rayon du cercle ajusté pour tenir compte de l'épaisseur
    Offset center = Offset(size.width / 2, size.height / 2);

    // Dessiner le cercle
    canvas.drawCircle(center, radius, circlePaint);

    // Dessiner l'aiguille (arc partiel)
    // double startAngle = -pi / 2 + 2 * pi * progress; // Début de l'aiguille (en haut) avec l'angle en fonction du progrès
    //double sweepAngle = pi / 30; // Longueur de l'aiguille (par exemple, 12 degrés)

    double startAngle =
        -pi / 2 - 2 * pi * progress; // Inverser la direction ici
    double sweepAngle = pi / 30;

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
