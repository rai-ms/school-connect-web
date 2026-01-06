import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_type_def.dart' show FVoid;
import '../../../../core/base/logger/app_logger_impl.dart';

class AnimatedTypingText extends StatefulWidget {
  const AnimatedTypingText({
    super.key,
    required this.texts,
    this.textStyle,
    this.animationDuration,
    this.showCursor = true,
    this.cursorDuration,
    this.repeat = true,
    this.cursorText = "|",
  });
  final List<String> texts;
  final TextStyle? textStyle;
  final Duration? animationDuration;
  final Duration? cursorDuration;
  final bool showCursor;
  final bool repeat;
  final String cursorText;

  @override
  State<AnimatedTypingText> createState() => _AnimatedTypingTextState();
}

class _AnimatedTypingTextState extends State<AnimatedTypingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _typingAnimation;

  List<String> _textsToType = ["Welcome to Flutter!", "Enjoy coding!"];
  int _currentTextIndex = 0;
  String get _currentText => _textsToType[_currentTextIndex];

  bool _showCursor = true;

  @override
  void initState() {
    super.initState();
    _textsToType = widget.texts;
    _showCursor = widget.showCursor;
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );
    cursor = widget.cursorText;
    _typingAnimation =
        IntTween(begin: 0, end: _currentText.length).animate(_controller)
          ..addListener(() {
            if(context.mounted)setState(() {});
          })
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              if (widget.showCursor) await _blinkCursor();
              if (!widget.repeat &&
                  ((_currentTextIndex) == _textsToType.length - 1)) {
                Log.d("RETURN");
                if(context.mounted) {
                  setState(() {
                  cursor = "";
                });
                }
                return;
              }
              _restartTyping();
            }
          });
    _controller.forward();
  }

  FVoid _blinkCursor() async {
    for (int i = 0; i < 4; i++) {
      if(context.mounted) {
        setState(() {
        _showCursor = !_showCursor;
      });
      }
      await Future.delayed(
        widget.cursorDuration ?? const Duration(milliseconds: 250),
      ); // 250ms blink interval
    }
  }

  void _restartTyping() {
    if(context.mounted) {
      setState(() {
      _currentTextIndex = (_currentTextIndex + 1) % _textsToType.length;
    });
    }
    _controller.reset();
    _typingAnimation =
        IntTween(begin: 0, end: _currentText.length).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _controller.forward();
  }

  String cursor = "|";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentText.substring(0, _typingAnimation.value) +
          (_showCursor ? cursor : ''),
      style: widget.textStyle,
    );
  }
}
