import 'package:flutter/material.dart';

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
    double startAngle = -3.141592653589793 / 2 +
        2 *
            3.141592653589793 *
            progress; // Début de l'aiguille (en haut) avec l'angle en fonction du progrès
    double sweepAngle = 3.141592653589793 /
        30; // Longueur de l'aiguille (par exemple, 12 degrés)
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