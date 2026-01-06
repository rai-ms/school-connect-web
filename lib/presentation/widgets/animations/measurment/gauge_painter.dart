import 'package:flutter/material.dart';
import 'dart:math' as math;

class GaugePainter extends CustomPainter {
  GaugePainter({
    required this.ratio,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double ratio;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final Paint trackPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw track (full circle)
    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress arc (start at -90 degrees for top)
    final double startAngle = -math.pi / 2;
    final double sweepAngle = 2 * math.pi * ratio;
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.ratio != ratio ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}