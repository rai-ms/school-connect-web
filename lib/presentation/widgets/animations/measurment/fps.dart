import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FpsOverlay extends StatefulWidget {
  const FpsOverlay({super.key});

  @override
  State<FpsOverlay> createState() => _FpsOverlayState();
}

class _FpsOverlayState extends State<FpsOverlay> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  int _frames = 0;
  double _fps = 0;
  late DateTime _lastTime;

  @override
  void initState() {
    super.initState();
    _lastTime = DateTime.now();

    _ticker = createTicker((_) {
      _frames++;
      final now = DateTime.now();
      final diff = now.difference(_lastTime).inMilliseconds;

      if (diff >= 1000) {
        setState(() {
          _fps = _frames * 1000 / diff;
          _frames = 0;
          _lastTime = now;
        });
      }
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'FPS: ${_fps.toStringAsFixed(1)}',
          style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
