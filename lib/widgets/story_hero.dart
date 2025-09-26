import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StickerSet {
  final String? watercolor; // dragon
  final String? cutout;     // robot
  final String? chibi;      // pig
  final String? pixel;      // fairy
  final String? lowpoly;    // unicorn
  const StickerSet({
    this.watercolor,
    this.cutout,
    this.chibi,
    this.pixel,
    this.lowpoly,
  });
}

class StoryHero extends StatefulWidget {
  final String bgUrl;                 // <-- panoramic fantasy BG (closer to image #1)
  final StickerSet stickers;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final VoidCallback? onCta;

  const StoryHero({
    super.key,
    required this.bgUrl,
    this.stickers = const StickerSet(),
    this.title = "Create magical stories & art",
    this.subtitle =
        "From flying pigs & friendly dragons to cute robots & caped heroes—mix styles and make it yours.",
    this.ctaLabel = "Try it now",
    this.onCta,
  });

  @override
  State<StoryHero> createState() => _StoryHeroState();
}

class _StoryHeroState extends State<StoryHero> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // small looping float
  double _float(double t, {double amp = 8, double phase = 0}) {
    return math.sin((t * 2 * math.pi) + phase) * amp;
  }

  @override
  Widget build(BuildContext context) {
    final t = _ctrl.value;
    return Container(
      height: 650,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Background image - Your background.jpg
            Positioned.fill(
              child: Image.asset(
                'assets/storysparkbgimage2.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  print('Background image failed to load: $error');
                  // Show gradient if background.jpg fails
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6366F1),
                          Color(0xFF8B5CF6),
                          Color(0xFFEC4899),
                          Color(0xFFF59E0B),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Starry vignette + vertical gradient for text legibility
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0x00000000),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.55),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            // soft vignette corners
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.7, -0.2),
                    radius: 1.2,
                    colors: [Color(0x26000000), Colors.transparent],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),

            // StorySpark Logo (centered, floating gently) - Clean!
            Positioned(
              left: 0,
              right: 0,
              top: -50 + _float(t, amp: 8, phase: 0.5),
              child: Center(
                child: Image.asset(
                  'assets/storyspark_logo.png',
                  width: 500,
                  height: 500,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('PNG logo failed: $error');
                    return const Icon(
                      Icons.bolt,
                      size: 100,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),

            // Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: const [Shadow(blurRadius: 8, color: Colors.black54)],
                          ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white.withOpacity(0.95),
                              height: 3.35,
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.grey.shade900,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      onPressed: widget.onCta,
                      child: Text(widget.ctaLabel),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for StorySpark logo as fallback
class StorySparkLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Blue lightning bolt (left)
    final bluePaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
      ).createShader(Rect.fromLTWH(0, 0, size.width / 2, size.height));
    
    final bluePath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.1)
      ..lineTo(size.width * 0.45, size.height * 0.4)
      ..lineTo(size.width * 0.35, size.height * 0.4)
      ..lineTo(size.width * 0.3, size.height * 0.9)
      ..lineTo(size.width * 0.05, size.height * 0.6)
      ..lineTo(size.width * 0.15, size.height * 0.6)
      ..close();
    
    canvas.drawPath(bluePath, bluePaint);
    
    // Yellow lightning bolt (right)
    final yellowPaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
      ).createShader(Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height));
    
    final yellowPath = Path()
      ..moveTo(size.width * 0.55, size.height * 0.1)
      ..lineTo(size.width * 0.8, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.4)
      ..lineTo(size.width * 0.95, size.height * 0.9)
      ..lineTo(size.width * 0.7, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height * 0.6)
      ..close();
    
    canvas.drawPath(yellowPath, yellowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


