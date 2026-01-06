

import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {

    final Shader linearGradient = LinearGradient(
      colors: <Color>[
        Color(0xFF00E1DA),
        Color(0xFFE10071),
      ],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Text(text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          ..shader = linearGradient,
      ),

    );
  }
}
