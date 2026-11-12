import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    this.tabletLayout,
  });

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isTablet(context) && tabletLayout != null) {
          return tabletLayout!;
        }
        return mobileLayout;
      },
    );
  }
}