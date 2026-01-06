import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LightBoldText extends StatelessWidget {
  const LightBoldText({
    super.key,
    this.maxLines,
    required this.text1,
    required this.text2,
    this.fontSize1,
    this.fontSize2,
    this.style1,
    this.style2,
    this.onTap,
    this.textAlign = TextAlign.start
  });
  final int? maxLines;
  final String text1, text2;
  final double? fontSize1, fontSize2;
  final TextStyle? style1, style2;
  final VoidCallback? onTap;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      textAlign: textAlign,
      text: TextSpan(
          children: [
            TextSpan(
              text: text1,
              style: style1 ?? Theme.of(context).textTheme.headlineMedium?.
              copyWith(
                fontSize: fontSize1,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = onTap,
              text: " $text2",
              style: style2 ?? Theme.of(context).textTheme.headlineMedium?.
              copyWith(
                  fontSize: fontSize2,
                  fontWeight: FontWeight.w700
              ),
            ),
          ]
      ),
      overflow: TextOverflow.ellipsis,
      textScaler: const TextScaler.linear(1.0),
    );
  }
}
