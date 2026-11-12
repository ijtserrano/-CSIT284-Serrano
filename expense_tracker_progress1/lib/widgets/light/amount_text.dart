import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/light_theme.dart';

/// "$87,457.85" where the cents can have their own (lighter) colour.
class AmountText extends StatelessWidget {
  const AmountText(
    this.value, {
    super.key,
    this.size = 16,
    this.weight = FontWeight.w600,
    this.color = LightColors.ink,
    this.centsColor,
  });
  final double value;
  final double size;
  final FontWeight weight;
  final Color color;
  final Color? centsColor;

  @override
  Widget build(BuildContext context) {
    final fixed = value.abs().toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = NumberFormat('#,##0').format(int.parse(parts.first));
    final base = TextStyle(fontSize: size, fontWeight: weight, color: color, height: 1.2);
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: '\$$whole', style: base),
        TextSpan(text: '.${parts.last}', style: base.copyWith(color: centsColor ?? color)),
      ]),
    );
  }
}