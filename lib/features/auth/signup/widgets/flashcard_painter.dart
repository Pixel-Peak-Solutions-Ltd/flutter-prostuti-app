import 'package:flutter/material.dart';

class ModernFlashcardBackgroundPainter extends CustomPainter {
  final Color baseColor;

  ModernFlashcardBackgroundPainter({
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final Color lighterColor1 = HSLColor.fromColor(baseColor)
        .withLightness(
            (HSLColor.fromColor(baseColor).lightness + 0.45).clamp(0.0, 1.0))
        .toColor();

    final Color lighterColor2 = HSLColor.fromColor(baseColor)
        .withLightness(
            (HSLColor.fromColor(baseColor).lightness + 0.3).clamp(0.0, 1.0))
        .toColor();

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        lighterColor1,
        lighterColor1,
        lighterColor2,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);

    _paintDecorativeElements(canvas, size, baseColor);
  }

  void _paintDecorativeElements(Canvas canvas, Size size, Color color) {
    final circlePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width - 40, 30),
      80,
      circlePaint,
    );

    final smallCirclePaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(40, size.height - 30),
      25,
      smallCirclePaint,
    );

    final pathPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.9,
      size.height * 0.5,
    );

    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
