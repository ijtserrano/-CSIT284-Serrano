import 'dart:math' as math;
import 'package:flutter/material.dart';

class DonutSegment {
  const DonutSegment({required this.fraction, required this.color, this.hatched = false});
  final double fraction; // 0..1
  final Color color;
  final bool hatched;
}

class DonutChart extends StatefulWidget {
  const DonutChart({
    super.key,
    required this.segments,
    required this.center,
    this.size = 270,
    this.strokeWidth = 62,
    this.initialSelected = 0,
  });
  final List<DonutSegment> segments;
  final Widget center;
  final double size;
  final double strokeWidth;
  final int? initialSelected;

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  static const double _gap = 0.05; // radians between segments
  late int? _selected = widget.initialSelected;

  double _startOf(int index) {
    var a = -math.pi / 2;
    for (var i = 0; i < index; i++) {
      a += widget.segments[i].fraction * 2 * math.pi;
    }
    return a;
  }

  void _onTap(Offset p) {
    final c = Offset(widget.size / 2, widget.size / 2);
    final d = p - c;
    final outer = widget.size / 2;
    final inner = outer - widget.strokeWidth;
    if (d.distance < inner || d.distance > outer) {
      setState(() => _selected = null);
      return;
    }
    var angle = math.atan2(d.dy, d.dx) + math.pi / 2; // 0 at top, clockwise
    if (angle < 0) angle += 2 * math.pi;
    var acc = 0.0;
    for (var i = 0; i < widget.segments.length; i++) {
      acc += widget.segments[i].fraction * 2 * math.pi;
      if (angle <= acc) {
        setState(() => _selected = widget.segments[i].hatched ? null : i);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    Widget? tooltip;
    if (_selected != null) {
      final seg = widget.segments[_selected!];
      final mid = _startOf(_selected!) + seg.fraction * math.pi;
      final r = s / 2 - 4;
      final pos = Offset(s / 2 + math.cos(mid) * r, s / 2 + math.sin(mid) * r);
      tooltip = Positioned(
        left: pos.dx - 20,
        top: pos.dy - 14,
        child: IgnorePointer(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: Text(
              '${(seg.fraction * 100).round()}%',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (d) => _onTap(d.localPosition),
      child: SizedBox(
        width: s,
        height: s,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(s, s),
              painter: _DonutPainter(widget.segments, widget.strokeWidth, _gap),
            ),
            widget.center,
            if (tooltip != null) tooltip,
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.segments, this.stroke, this.gap);
  final List<DonutSegment> segments;
  final double stroke;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final outer = size.width / 2;
    final inner = outer - stroke;
    const corner = 5.0; // rounded corners: inset path + round-joined stroke
    final midR = (outer + inner) / 2;
    final da = corner / midR;
    var start = -math.pi / 2;

    for (final seg in segments) {
      final sweep = seg.fraction * 2 * math.pi;
      final a0 = start + gap / 2 + da;
      final sw = sweep - gap - 2 * da;
      final path = Path()
        ..arcTo(Rect.fromCircle(center: c, radius: outer - corner), a0, sw, true)
        ..arcTo(Rect.fromCircle(center: c, radius: inner + corner), a0 + sw, -sw, false)
        ..close();
      final color = seg.hatched ? const Color(0xFFE9E9EC) : seg.color;
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = corner * 2
          ..strokeJoin = StrokeJoin.round,
      );
      if (seg.hatched) {
        canvas.save();
        canvas.clipPath(path);
        final line = Paint()
          ..color = const Color(0xFFCFCFD4)
          ..strokeWidth = 1.5;
        for (var x = -size.height; x < size.width; x += 7) {
          canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), line);
        }
        canvas.restore();
      }
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.segments != segments || old.stroke != stroke || old.gap != gap;
}