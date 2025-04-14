import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText({
    super.key,
    required this.text,
    required this.gradient,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Use TextPainter to measure text width
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    final textSize = textPainter.size;

    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, textSize.width, textSize.height),
        );
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: style.copyWith(color: Colors.white), // white so gradient shows
      ),
    );
  }
}