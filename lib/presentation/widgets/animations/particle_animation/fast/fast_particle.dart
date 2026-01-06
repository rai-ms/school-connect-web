

import 'package:flutter/animation.dart';
import 'dart:math';

class FastParticle {
  double angle;     // angle in radians
  double radius;    // distance from center
  double speed;     // angular speed (radians per tick)
  double size;
  int colorValue;

  double x = 0;
  double y = 0;

  FastParticle({
    required this.angle,
    required this.radius,
    required this.speed,
    required this.size,
    required this.colorValue,
  });

  void update(double centerX, double centerY) {
    angle += speed; // clockwise rotation

    x = centerX + radius * cos(angle);
    y = centerY + radius * sin(angle);
  }

  Color get color => Color(colorValue);
}
