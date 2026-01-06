import 'package:flutter/material.dart';
import 'dart:math';
import 'app_loader.dart';

class AppPullToRefresh extends StatefulWidget {
  const AppPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.triggerOffset = 80,
    this.maxPullExtent = 120,
    this.indicator,
  }) : assert(maxPullExtent >= triggerOffset, 'maxPullExtent must be >= triggerOffset');

  final Widget child;

  final Future<void> Function() onRefresh;

  final double triggerOffset;

  final double maxPullExtent;

  final Widget? indicator;

  @override
  State<AppPullToRefresh> createState() => _AppPullToRefreshState();
}

class _AppPullToRefreshState extends State<AppPullToRefresh> {
  double dragOffset = 0.0;
  bool isRefreshing = false;

  Future<void> _refresh() async {
    setState(() => isRefreshing = true);
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() {
          isRefreshing = false;
          dragOffset = 0.0;
        });
      }

    }
  }

  bool _handleScroll(ScrollNotification n) {
    if (n.depth != 0) return false;
    if (isRefreshing) return false;

    if (n is ScrollUpdateNotification) {
      final atTop = n.metrics.pixels <= 0;
      final dragging = n.dragDetails != null;
      if (atTop && dragging) {
        final delta = -(n.scrollDelta ?? 0.0);
        if (delta > 0) {
          setState(() {
            dragOffset = (dragOffset + delta).clamp(0.0, widget.maxPullExtent);
          });
        }
      }
    } else if (n is OverscrollNotification) {
      final atTop = n.metrics.pixels <= 0;
      if (atTop) {
        final delta = n.overscroll;
        setState(() {
          dragOffset = (dragOffset + max(0.0, delta)).clamp(0.0, widget.maxPullExtent);
        });
      }
    } else if (n is ScrollEndNotification) {
      if (dragOffset >= widget.triggerOffset && !isRefreshing) {
        _refresh();
      } else {
        setState(() => dragOffset = 0.0);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (dragOffset / widget.triggerOffset).clamp(0.0, 1.0);
    final indicator = RotatingDotsLoader(
      dotCount: progress.toInt(),
    );

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: Stack(
        children: [
          widget.child,
          if (dragOffset > 0 || isRefreshing)
            Positioned(
              top: (isRefreshing ? widget.triggerOffset : dragOffset) - 20,
              left: 0,
              right: 0,
              child: Center(
                child: isRefreshing
                    ? indicator
                    : RotatingDotsLoader(
                  dotCount: progress.toInt(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
