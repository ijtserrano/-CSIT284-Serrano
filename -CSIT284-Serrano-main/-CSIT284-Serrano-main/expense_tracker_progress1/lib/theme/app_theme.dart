import 'package:flutter/material.dart';
import '../models/expense.dart';

final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

class AppColors {
  static const Color teal = Color(0xFF0F766E);
  static const Color coral = Color(0xFFFF9731);
  static const Color cream = Color(0xFFFFFFF8);
  static const Color night = Color(0xFF0E181A);

  static final Map<Category, Color> categoryColors = {
    Category.food: const Color(0xFFF97316),
    Category.groceries: const Color(0xFF22C55E),
    Category.travel: const Color(0xFF0EA5E9),
    Category.leisure: const Color(0xFFEC4899),
    Category.bills: const Color(0xEAB308FF),
    Category.health: const Color(0xEF4444FF),
    Category.work: const Color(0x885CF6FF),
  };
}

class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: brightness,
    ).copyWith(
      secondary: AppColors.coral,
      surface: isLight ? AppColors.cream : AppColors.night,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );
  }
}