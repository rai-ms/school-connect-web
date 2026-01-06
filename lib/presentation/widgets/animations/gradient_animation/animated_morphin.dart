import 'dart:math';
import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';

class AnimatedMorphingContainer extends StatefulWidget {
  const AnimatedMorphingContainer({super.key, this.height = 250, this.width = 250, this.color1, this.color2});
  final double height, width;
  final MorphingColor? color1, color2;

  @override
  State<AnimatedMorphingContainer> createState() => _AnimatedMorphingContainerState();
}

class _AnimatedMorphingContainerState extends State<AnimatedMorphingContainer>
    with TickerProviderStateMixin {
  late AnimationController colorController;
  late AnimationController shapeController;
  late Animation<Color?> color1;
  late Animation<Color?> color2;

  @override
  void initState() {
    super.initState();

    colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    shapeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    color1 = ColorTween(
      begin: widget.color1?.start ?? const Color(0xFF1E1802),
      end: widget.color1?.end ?? const Color(0xFF1C1604),
    ).animate(colorController);

    color2 = ColorTween(
      begin: widget.color2?.start ?? const Color(0xFF1C0321),
      end: widget.color2?.end ?? const Color(0xFF1E0220),
    ).animate(colorController);
  }

  @override
  void dispose() {
    colorController.dispose();
    shapeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([colorController, shapeController]),
      builder: (_, __) {
        return Center(
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              children: [
                // Blurred glowing edge
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: ClipPath(
                    clipper: BlobClipper(progress: shapeController.value),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (color1.value ?? Colors.blue).withValues(alpha: 0.6),
                            (color2.value ?? Colors.pink).withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),

                // Main shape (sharp inside but layered under soft blur)
                ClipPath(
                  clipper: BlobClipper(progress: shapeController.value),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color1.value ?? Colors.blue,
                          color2.value ?? Colors.pink,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Generates a blob using polar points + progress-based wobble
class BlobClipper extends CustomClipper<Path> {
  final double progress;
  BlobClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final path = Path();
    const int points = 24;
    final double step = 2 * pi / points;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double radiusX = size.width / 2;
    final double radiusY = size.height / 2;

    final List<Offset> vertices = [];

    for (int i = 0; i < points; i++) {
      final double angle = i * step;
      final double wobble = sin(progress * 2 * pi + angle * 4) * 6;

      final double x = center.dx + (radiusX + wobble) * cos(angle);
      final double y = center.dy + (radiusY + wobble) * sin(angle);

      vertices.add(Offset(x, y));
    }

    path.moveTo(vertices[0].dx, vertices[0].dy);

    for (int i = 0; i < vertices.length; i++) {
      final Offset p1 = vertices[i];
      final Offset p2 = vertices[(i + 1) % vertices.length];
      final Offset mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
      path.quadraticBezierTo(p1.dx, p1.dy, mid.dx, mid.dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


class MorphingColor{
  final Color start;
  final Color end;

  const MorphingColor({
    required this.start,
    required this.end
  });
}