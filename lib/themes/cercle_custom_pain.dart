/*
  Animation with Custom Paint
  Created by Epiphane KOUTSAVA
*/

import 'dart:math';
import 'package:animeheart/components/animation.dart';
import 'package:flutter/material.dart';

class CircleCustomPain extends StatefulWidget {
  const CircleCustomPain({super.key});

  @override
  _CircleCustomPainState createState() => _CircleCustomPainState();
}

class _CircleCustomPainState extends State<CircleCustomPain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  //initialisation sens direction
  int _direction = 1;

  // Angle initial de l'aiguille
  double _currentAngle = 0.0;
  // Couleur initiale de l'aiguille
  Color _needleColor = Colors.red;
  bool _isAnimating = true;

  //sliver
  int ratings = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(microseconds: 100 - ratings),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {
        _currentAngle += _direction * (2 * pi / ((100 - ratings) * 2));
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
              //animation pour battement de cœur et grand circle pour circules l'aiguille
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(100, 100), // Taille du canevas
                    painter:
                        CircleWithNeedlePainter(_currentAngle, _needleColor),
                    child: Center(
                      child: HeartAnimation(
                          durationInSeconds: (100 - ratings),
                          isAnimating: _isAnimating,
                          direction: _direction),
                    ),
                  );
                },
              ),
              //Slider rangepour changer la vitesse de battement de cœur
              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: Slider(
                    value: ratings.toDouble(),
                    onChanged: (newRating) {
                      setState(() => ratings = newRating.toInt());
                    },
                    min: 1,
                    max: 99,
                    divisions: 99,
                    label: "$ratings",
                    thumbColor:
                        _direction == 1 ? Colors.red[600] : Colors.blue[600],
                    activeColor:
                        _direction == 1 ? Colors.red[400] : Colors.blue[400]),
              ),

              //Les buttons pour aller à gauche, à droit et pour stoper le cœur
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
                        // Rotation de 180 degrés sur l'axe Y
                        transform: Matrix4.rotationY(pi),
                        child: const Icon(Icons.reply),
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
