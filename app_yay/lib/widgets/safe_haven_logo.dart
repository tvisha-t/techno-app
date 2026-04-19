import 'package:flutter/material.dart';

// ─ Purple Aesthetic Color Palette ─────────────────────
const Color _darkPurple = Color(0xFF5B2D8E);
const Color _mediumPurple = Color(0xFF8A5C9C);
const Color _lightPurple = Color(0xFFE5D4F0);
const Color _accentPurple = Color(0xFF9C6FD6);
// ───────────────────────────────────────────────────

/// Custom SafeHaven Logo with gradient circles and lock icon
class SafeHavenLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const SafeHavenLogo({
    super.key,
    this.size = 120,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gradient circles background with lock icon
        Stack(
          alignment: Alignment.center,
          children: [
            // Outermost light purple circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _lightPurple.withOpacity(0.4),
                boxShadow: [
                  BoxShadow(
                    color: _darkPurple.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            // Middle accent purple circle
            Container(
              width: size * 0.7,
              height: size * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentPurple.withOpacity(0.6),
              ),
            ),
            // Inner darker purple circle
            Container(
              width: size * 0.45,
              height: size * 0.45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _mediumPurple,
              ),
            ),
            // Lock icon
            Icon(
              Icons.lock_rounded,
              size: size * 0.3,
              color: Colors.white,
            ),
          ],
        ),
        if (showText) ...[
          const SizedBox(height: 20),
          // "SAFE HAVEN" text with shadow
          Stack(
            alignment: Alignment.center,
            children: [
              // Shadow layer
              Text(
                'SAFE HAVEN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.2),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),
              // Main text
              Text(
                'SAFE HAVEN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
