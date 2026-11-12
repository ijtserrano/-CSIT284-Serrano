import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.percent, required this.color, this.size = 46});
  final int percent;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(percent / 100, color),
        child: Center(
          child: Text(
            '$percent%',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color);
  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const w = 3.5;
    final rect = Rect.fromLTWH(w / 2, w / 2, size.width - w, size.height - w);
    canvas.drawArc(
      rect, 0, 2 * math.pi, false,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w,
    );
    canvas.drawArc(
      rect, -math.pi / 2, 2 * math.pi * value, false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.value != value || old.color != color;
}