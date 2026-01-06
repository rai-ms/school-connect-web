

import 'package:flutter/material.dart';

import 'fast_particle.dart';

class FastParticlePainter extends CustomPainter {
  final List<FastParticle> particles;
  final Size size;

  FastParticlePainter(this.particles, this.size);

  @override
  void paint(Canvas canvas, Size _) {
    final paint = Paint();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (var p in particles) {
      p.update(centerX, centerY);
      paint.color = p.color.withValues(alpha: 0.7);
      canvas.drawCircle(Offset(p.x, p.y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

