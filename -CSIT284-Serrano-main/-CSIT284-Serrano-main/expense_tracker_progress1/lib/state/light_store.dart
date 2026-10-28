import 'package:flutter/foundation.dart';
import '../models/light_plan_model.dart';

/// Tiny app-wide state so every screen reacts when data changes.
class LightStore {
  LightStore._();
  static final LightStore instance = LightStore._();

  static const double _baseBalance = 87457.85;
  static const double _baseExpenses = 8145.78;
  static const double income = 4875.12;

  final ValueNotifier<List<MoneyTransaction>> transactions =
      ValueNotifier<List<MoneyTransaction>>(List.of(demoTransactions));
  final ValueNotifier<List<BudgetItem>> budgets =
      ValueNotifier<List<BudgetItem>>(List.of(demoBudgets));
  final ValueNotifier<String> month = ValueNotifier<String>('November 2025');
  final ValueNotifier<bool> unread = ValueNotifier<bool>(true);

  double get _added =>
      transactions.value.where((t) => t.added).fold(0.0, (sum, t) => sum + t.amount);

  double get balance => _baseBalance - _added;
  double get expenses => _baseExpenses + _added;

  void addExpense(MoneyTransaction t) => transactions.value = [t, ...transactions.value];

  void remove(MoneyTransaction t) =>
      transactions.value = transactions.value.where((x) => !identical(x, t)).toList();

  void restore(MoneyTransaction t, int index) {
    final list = [...transactions.value];
    list.insert(index > list.length ? list.length : index, t);
    transactions.value = list;
  }

  void addToBudget(int index, double amount) {
    final list = [...budgets.value];
    list[index] = list[index].addSaved(amount);
    budgets.value = list;
  }
}