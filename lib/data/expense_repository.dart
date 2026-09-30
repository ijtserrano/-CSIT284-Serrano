import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';
import 'expense_codec.dart';

/// Persists expenses, budget and theme locally.
/// Swap the internals for drift/sqflite later without touching the UI.
class ExpenseRepository {
  const ExpenseRepository();

  static const _expensesKey = 'expenses_v1';
  static const _backupKey = 'expenses_v1_backup';
  static const _themeKey = 'theme_mode';
  static const _budgetKey = 'monthly_budget_cents';

  // Writes run one after another, so fast add/delete/undo can't finish
  // out of order and leave stale data on disk.
  static Future<void> _queue = Future.value();

  Future<List<Expense>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_expensesKey);
    if (raw == null) return [];
    final result = decodeExpenses(raw);
    if (result.skipped > 0) {
      // Keep the original text so nothing is lost when we save again.
      await prefs.setString(_backupKey, raw);
    }
    return result.expenses;
  }

  Future<void> save(List<Expense> expenses) {
    final json = encodeExpenses(expenses); // snapshot now
    _queue = _queue.then<void>((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_expensesKey, json);
    }).catchError((_) {});
    return _queue;
  }

  Future<int?> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_budgetKey);
  }

  Future<void> saveBudget(int? cents) async {
    final prefs = await SharedPreferences.getInstance();
    if (cents == null) {
      await prefs.remove(_budgetKey);
    } else {
      await prefs.setInt(_budgetKey, cents);
    }
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_themeKey);
    try {
      return name == null ? ThemeMode.system : ThemeMode.values.byName(name);
    } catch (_) {
      return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }
}