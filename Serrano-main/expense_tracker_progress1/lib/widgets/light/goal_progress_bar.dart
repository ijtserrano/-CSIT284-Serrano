import 'package:flutter/material.dart';
import '../../theme/light_theme.dart';

/// Filled bar + thumb + hatched "where you should be" part + light track.
class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({
    super.key,
    required this.progress,
    required this.expected,
    this.color = LightColors.coral,
  });
  final double progress;
  final double expected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      width: double.infinity,
      child: CustomPaint(painter: _GoalBarPainter(progress, expected, color)),
    );
  }
}

class _GoalBarPainter extends CustomPainter {
  _GoalBarPainter(this.progress, this.expected, this.color);
  final double progress;
  final double expected;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const h = 12.0;
    final top = (size.height - h) / 2;
    final radius = Radius.circular(h / 2);
    final track = RRect.fromLTRBR(0, top, size.width, top + h, radius);
    final fillEnd = size.width * progress;
    final hatchEnd = size.width * expected;

    canvas.drawRRect(track, Paint()..color = color.withValues(alpha: 0.14));

    canvas.save();
    canvas.clipRRect(track);
    canvas.clipRect(Rect.fromLTRB(fillEnd, top, hatchEnd, top + h));
    final line = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1.4;
    for (var x = fillEnd - h; x < hatchEnd; x += 5) {
      canvas.drawLine(Offset(x, top + h), Offset(x + h, top), line);
    }
    canvas.restore();

    canvas.drawRRect(RRect.fromLTRBR(0, top, fillEnd, top + h, radius), Paint()..color = color);

    final thumb = Offset(fillEnd, size.height / 2);
    canvas.drawCircle(thumb, 8, Paint()..color = Colors.white);
    canvas.drawCircle(
      thumb, 6.5,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5,
    );
  }

  @override
  bool shouldRepaint(covariant _GoalBarPainter old) =>
      old.progress != progress || old.expected != expected || old.color != color;
}