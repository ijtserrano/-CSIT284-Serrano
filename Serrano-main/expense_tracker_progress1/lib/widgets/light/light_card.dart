import 'package:flutter/material.dart';
import '../../theme/light_theme.dart';

class LightCard extends StatelessWidget {
  const LightCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 20,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: LightColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class SoftIconBox extends StatelessWidget {
  const SoftIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
    this.circle = false,
  });
  final IconData icon;
  final Color color;
  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: color, size: size * 0.46),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.onBack, this.trailing});
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          color: LightColors.ink,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: LightColors.ink),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}