import 'package:flutter/material.dart';

class SlideFadeIn extends StatelessWidget {
  const SlideFadeIn({
    super.key,
    required this.animate,
    required this.child,
  });

  final bool animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}