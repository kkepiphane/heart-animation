/*
  Animation with Custom Paint
  Created by Epiphane KOUTSAVA
*/

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
  double _currentAngle = 0.0; // Angle initial de l'aiguille
  Color _needleColor = Colors.blue; // Couleur initiale de l'aiguille
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(microseconds: widget.durationInSeconds),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _currentAngle += _direction * (2 * pi / (widget.durationInSeconds * 2));
        if (_currentAngle >= 2 * pi) {
          _currentAngle -= 2 * pi;
        } else if (_currentAngle <= -2 * pi) {
          _currentAngle += 2 * pi;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pressleft() {
    setState(() {
      _direction = 1;
      _needleColor = Colors.red;
    });
  }

  void _stopanime() {
    setState(() {
      if (_controller.isAnimating) {
        _controller.stop();
        _isAnimating = false;
      } else {
        _controller.repeat();
        _isAnimating = true;
      }
    });
  }

  void _pressrigth() {
    setState(() {
      _direction = -1;
      _needleColor = Colors.blue;
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
                        CircleWithNeedlePainter(_currentAngle, _needleColor),
                    child: Center(
                      child: HeartAnimation(
                        durationInSeconds: widget.durationInSeconds,
                        isAnimating: _isAnimating,
                      ),
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
                      tooltip: 'aller à gauche',
                      child: const Icon(Icons.reply),
                    ),
                    const SizedBox(width: 30),
                    FloatingActionButton(
                      onPressed: _stopanime,
                      tooltip: 'Mettre pause et rejouer',
                      child: Icon(_controller.isAnimating
                          ? Icons.stop
                          : Icons.play_arrow),
                    ),
                    const SizedBox(width: 30),
                    FloatingActionButton(
                      onPressed: _pressrigth,
                      tooltip: 'Aller à droit',
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(
                            pi), // Rotation de 180 degrés sur l'axe Y
                        child: Icon(Icons.reply),
                      ),
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
  final double currentAngle;
  final Color needleColor;

  CircleWithNeedlePainter(this.currentAngle, this.needleColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    // Épaisseur de l'aiguille
    Paint needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    double startAngle = currentAngle;

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
    return oldDelegate.currentAngle != currentAngle ||
        oldDelegate.needleColor != needleColor;
  }
}
