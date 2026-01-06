import 'dart:math';
import 'package:flutter/material.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'fast_particle.dart';
import 'fast_particle_painter.dart';

class FastParticleAnimation extends StatefulWidget {
  final int count;
  final Color color;
  const FastParticleAnimation({super.key, this.count = 200, required this.color});

  @override
  State<FastParticleAnimation> createState() => _FastParticleAnimationState();
}

class _FastParticleAnimationState extends State<FastParticleAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ValueNotifier<List<FastParticle>> particles = ValueNotifier<List<FastParticle>>([]);
  final random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 100),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      particles.value = List.generate(widget.count, (_) => _createParticle(size));
    });
  }

  FastParticle _createParticle(Size size) {
    final maxRadius = size.shortestSide / 2;

    return FastParticle(
      angle: (random.nextDouble().toInt() >> 2).toDouble(),
      radius: random.nextDouble() * maxRadius,
      speed: 0.01 + random.nextDouble() * 0.01,
      size: (1 + (random.nextInt(4))).toDouble(),
      colorValue: widget.color.toARGB32(),
    );
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, child) {
        if (particles.value.isEmpty) return Space.z;
        return CustomPaint(
          painter: FastParticlePainter(particles.value, size),
          child: Container(),
        );
      }
    );
  }
}
