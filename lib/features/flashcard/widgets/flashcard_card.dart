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
    super.key,
    required this.frontText,
    required this.backText,
    this.onTts,
    this.onFavorite,
    this.isFavorite = false,
    this.flipKey,
    required this.backgroundColor,
  });

  @override
  FlashCardState createState() => FlashCardState();
}

class FlashCardState extends State<FlashCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    setState(() => _isTapped = true);
    _animationController.forward();
  }

  void _onTapUp() {
    setState(() => _isTapped = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapUp(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: FlipCard(
          key: widget.flipKey,
          front: _buildCardSide(widget.frontText, true),
          back: _buildCardSide(widget.backText, false),
          direction: FlipDirection.HORIZONTAL,
          speed: 400,
          // Slightly slower for better visual
          onFlip: () {
            // Optional haptic feedback
            // HapticFeedback.mediumImpact();
          },
        ),
      ),
    );
  }

  Widget _buildCardSide(String text, bool isFront) {
    // Create darker and lighter shades for gradient effect
    final Color lighterColor = _lightenColor(widget.backgroundColor, 0.2);
    final Color darkerColor = _darkenColor(widget.backgroundColor, 0.2);

    return Card(
      margin: const EdgeInsets.only(top: 8, left: 4, right: 4),
      elevation: 16,
      shadowColor: widget.backgroundColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [lighterColor, widget.backgroundColor, darkerColor],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Wavy background with improved design
              CustomPaint(
                size: const Size(double.infinity, double.infinity),
                painter: WaveBackgroundPainter(
                  baseColor: widget.backgroundColor,
                  animate: true,
                ),
              ),

              // Content with better layout
              Column(
                children: [
                  // Card controls
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Side indicator (front/back)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            isFront ? 'FRONT' : 'BACK',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            // TTS button
                            _buildActionButton(
                              onTap: widget.onTts,
                              iconWidget: SvgPicture.asset(
                                "assets/icons/flashcard_tts.svg",
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                                height: 22,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Favorite button
                            _buildActionButton(
                              onTap: widget.onFavorite,
                              iconWidget: SvgPicture.asset(
                                widget.isFavorite
                                    ? "assets/icons/favourite.svg"
                                    : "assets/icons/flashcard_favourite.svg",
                                colorFilter: ColorFilter.mode(
                                  widget.isFavorite ? Colors.red : Colors.white,
                                  BlendMode.srcIn,
                                ),
                                height: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tap to flip indicator
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: Colors.white.withOpacity(0.7),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Tap to flip",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Card content
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Swipe instruction at bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSwipeHint(
                          icon: Icons.arrow_back_ios,
                          text: "Don't know",
                        ),
                        Container(
                          height: 16,
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.white.withOpacity(0.3),
                        ),
                        _buildSwipeHint(
                          icon: Icons.arrow_forward_ios,
                          text: "Know it",
                        ),
                      ],
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

  Widget _buildActionButton({
    required VoidCallback? onTap,
    required Widget iconWidget,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: iconWidget,
        ),
      ),
    );
  }

  Widget _buildSwipeHint({
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.7),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
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
}

class WaveBackgroundPainter extends CustomPainter {
  final Color baseColor;
  final bool animate;

  WaveBackgroundPainter({required this.baseColor, this.animate = false});

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

    // Paint multiple waves with different opacities for a more layered effect
    _paintWaves(canvas, size, 0.15, 0.3, 0.4);
    _paintWaves(canvas, size, 0.1, 0.5, 0.6, reverse: true);
    _paintWaves(canvas, size, 0.05, 0.7, 0.8);
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

  void _paintWaves(Canvas canvas, Size size, double opacity, double startHeight,
      double amplitude,
      {bool reverse = false}) {
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();

    final startY = size.height * startHeight;
    path.moveTo(reverse ? size.width : 0, startY);

    // Add multiple wave points for more natural look
    final segmentWidth = size.width / 4;

    if (!reverse) {
      path.quadraticBezierTo(
        segmentWidth * 1,
        startY - (size.height * 0.1 * amplitude),
        segmentWidth * 2,
        startY,
      );

      path.quadraticBezierTo(
        segmentWidth * 3,
        startY + (size.height * 0.1 * amplitude),
        segmentWidth * 4,
        startY,
      );
    } else {
      path.quadraticBezierTo(
        segmentWidth * 3,
        startY + (size.height * 0.1 * amplitude),
        segmentWidth * 2,
        startY,
      );

      path.quadraticBezierTo(
        segmentWidth * 1,
        startY - (size.height * 0.1 * amplitude),
        0,
        startY,
      );
    }

    path.lineTo(reverse ? 0 : size.width, size.height);
    path.lineTo(reverse ? size.width : 0, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => animate;
}
