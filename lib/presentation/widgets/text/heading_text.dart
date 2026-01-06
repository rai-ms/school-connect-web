import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({super.key, required this.text, this.fontSize = 26, this.fontWeight = FontWeight.w700});
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight
      ),
      textScaler: const TextScaler.linear(1.0),
      textAlign: TextAlign.center,
    );
  }
}
