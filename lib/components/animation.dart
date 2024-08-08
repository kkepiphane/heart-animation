import 'package:flutter/material.dart';

class HeartAnimation extends StatefulWidget {
  final int durationInSeconds;
  final bool isAnimating;
  final int direction;

  HeartAnimation({
    required this.durationInSeconds,
    required this.isAnimating,
    required this.direction,
  });

  @override
  _HeartAnimationState createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int direction; // Initialisation de `direction`

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.durationInSeconds * 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    direction = widget.direction; // Initialisation de la direction

    if (!widget.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(covariant HeartAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }

    if (widget.direction != oldWidget.direction) {
      setState(() {
        direction = widget.direction;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(
        Icons.favorite,
        color: direction == 1
            ? Colors.red
            : Colors.blue, // Vérification correcte de la direction
        size: 110.0,
        semanticLabel: 'Heartbeat',
      ),
    );
  }
}
