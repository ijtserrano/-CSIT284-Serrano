import 'dart:math';
import 'package:flutter/material.dart';

class ScoreGauge extends StatelessWidget {
  const ScoreGauge({
    super.key,
    required this.scorePercentage,
    this.passingPercentage = 80.0,
  });

  final double scorePercentage;
  final double passingPercentage;

  @override
  Widget build(BuildContext context) {
    final bool isPassed = scorePercentage >= passingPercentage;
    final primaryColor = isPassed
        ? const Color(0xFF40916C) // Forest Green emerald accent
        : const Color(0xFFE57373); // Coral Red for fail

    return SizedBox(
      width: 240,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: GaugePainter(
              scorePercentage: scorePercentage,
              passingPercentage: passingPercentage,
              primaryColor: primaryColor,
            ),
          ),
          // Center Text and Status Icon
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your score ${scorePercentage.toInt()}%',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                isPassed ? Icons.check_rounded : Icons.close_rounded,
                size: 56,
                color: primaryColor,
              ),
            ],
          ),
          // "PASSING 80%" Side Label Indicator
          Positioned(
            right: 0,
            top: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 1,
                  color: Colors.white70,
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PASSING',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Text(
                      '${passingPercentage.toInt()}%',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  GaugePainter({
    required this.scorePercentage,
    required this.passingPercentage,
    required this.primaryColor,
  });

  final double scorePercentage;
  final double passingPercentage;
  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);
    final radius = size.width / 2 - 20;

    const startAngle = 135 * (pi / 180);
    const totalSweepAngle = 270 * (pi / 180);

    // Track Background Arc
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Score Fill Arc
    final scorePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Draw track background
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweepAngle,
      false,
      bgPaint,
    );

    // Draw score arc
    final scoreSweep = (scorePercentage / 100).clamp(0.0, 1.0) * totalSweepAngle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      scoreSweep,
      false,
      scorePaint,
    );

    // Draw Passing Indicator Dot
    final passAngle = startAngle + ((passingPercentage / 100) * totalSweepAngle);
    final dotX = center.dx + radius * cos(passAngle);
    final dotY = center.dy + radius * sin(passAngle);

    final dotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}