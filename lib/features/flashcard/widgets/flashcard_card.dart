// flashcard_card.dart
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FlashCard extends StatefulWidget {
  final String frontText;
  final String backText;
  final Function()? onTts;
  final Function()? onFavorite;
  final bool isFavorite;
  final GlobalKey<FlipCardState>? flipKey;
  final Color backgroundColor;

  const FlashCard({
    Key? key,
    required this.frontText,
    required this.backText,
    this.onTts,
    this.onFavorite,
    this.isFavorite = false,
    this.flipKey,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: widget.flipKey,
      front: _buildCardSide(widget.frontText, true),
      back: _buildCardSide(widget.backText, false),
      direction: FlipDirection.HORIZONTAL,
    );
  }

  Widget _buildCardSide(String text, bool isFront) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Wavy background
              CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter:
                    WaveBackgroundPainter(baseColor: widget.backgroundColor),
              ),

              // Content
              Column(
                children: [
                  // Card controls
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: widget.onTts,
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/icons/flashcard_tts.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: widget.onFavorite,
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              widget.isFavorite
                                  ? "assets/icons/favourite.svg"
                                  : "assets/icons/flashcard_favourite.svg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Card content
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveBackgroundPainter extends CustomPainter {
  final Color baseColor;

  WaveBackgroundPainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient colors based on the baseColor
    final Rect rect = Offset.zero & size;

    // Create lighter and darker shades of the base color
    final Color lighterColor = _lightenColor(baseColor, 0.15);
    final Color darkerColor = _darkenColor(baseColor, 0.15);

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        lighterColor,
        baseColor,
        darkerColor,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);

    // Paint the waves
    _paintWaves(canvas, size);
  }

  Color _lightenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  void _paintWaves(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // First wave
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);

    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.3,
    );

    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.3,
    );

    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, wavePaint);

    // Second wave (slightly darker)
    final wavePaint2 = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);

    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.5,
    );

    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.4,
      size.width,
      size.height * 0.5,
    );

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, wavePaint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
