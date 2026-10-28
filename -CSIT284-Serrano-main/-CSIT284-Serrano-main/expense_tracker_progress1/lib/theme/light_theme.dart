import 'package:flutter/material.dart';

abstract class LightColors {
  static const background = Color(0xFFF6F6F7);
  static const sheet = Color(0xFFFAFAFA);
  static const purple = Color(0xFF9B6BFF);
  static const purpleLight = Color(0xFFB892FF);
  static const purpleDark = Color(0xFF8B5CF6);
  static const purpleSoft = Color(0xFFEFE8FF);
  static const ink = Color(0xFF111111);
  static const muted = Color(0xFF8E8E93);
  static const border = Color(0xFFEDEDF0);
  static const coral = Color(0xFFFF6B4A);
  static const red = Color(0xFFE5174B);
  static const blue = Color(0xFF2E9BFF);
  static const green = Color(0xFF2FC76D);
  static const orange = Color(0xFFFF7A0F);
}

abstract class LightTheme {
  static ThemeData get data => ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: LightColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: LightColors.purple,
          brightness: Brightness.light,
          surface: LightColors.background,
        ),
        splashFactory: NoSplash.splashFactory,
      );
}