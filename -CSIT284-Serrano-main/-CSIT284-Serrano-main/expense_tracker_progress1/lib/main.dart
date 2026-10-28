import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import 'screens/light_main_wrapper.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ExpenseApp());

/// Lets mouse and trackpad drag-scroll lists in Chrome (default is touch only).
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        scrollBehavior: _AppScrollBehavior(),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: const LightMainWrapper(),
      ),
    );
  }
}