import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:meals2/screens/tabs.dart';

/// Lets the Settings screen switch between light, dark and system theme.
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

ThemeData buildTheme(Brightness brightness) {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: const Color.fromARGB(255, 131, 57, 0),
    ),
  );
  return base.copyWith(textTheme: GoogleFonts.latoTextTheme(base.textTheme));
}

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) => MaterialApp(
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: mode,
        home: const TabsScreen(),
      ),
    );
  }
}