import 'package:flutter/material.dart';

/// A custom painter that draws premium, modern abstract glowing waves
/// and credit card overlay details to give the balance card a Stripe/Apple Wallet look.
class WalletCardPainter extends CustomPainter {
  final Color primaryColor;

  WalletCardPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    // Draw background glowing circle 1 (top-right)
    paint.color = Colors.white.withValues(alpha: 0.08);
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.2),
      size.height * 0.6,
      paint,
    );

    // Draw background glowing circle 2 (bottom-right)
    paint.color = Colors.white.withValues(alpha: 0.05);
    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.85),
      size.height * 0.45,
      paint,
    );

    // Draw decorative wavy lines (fintech grid look)
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.9,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.1,
      size.width,
      size.height * 0.15,
    );
    canvas.drawPath(path, linePaint);

    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.75,
      size.width * 0.45,
      size.height * 0.4,
    );
    path2.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.05,
      size.width,
      size.height * 0.05,
    );
    canvas.drawPath(path2, linePaint);
  }

  @override
  bool shouldRepaint(covariant WalletCardPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }
}
