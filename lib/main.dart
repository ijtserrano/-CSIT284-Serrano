import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/expenses_screen.dart'; // Updated import

void main() => runApp(const ExpenseApp());

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        home: const ExpensesScreen(), // Updated to match expenses_screen.dart
      ),
    );
  }
}