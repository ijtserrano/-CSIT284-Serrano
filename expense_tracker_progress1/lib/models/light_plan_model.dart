import 'package:flutter/material.dart';
import '../theme/light_theme.dart';

class TxTag {
  const TxTag(this.icon, this.label, this.color);
  final IconData icon;
  final String label;
  final Color color;
}

class MoneyTransaction {
  const MoneyTransaction({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.balance,
    this.nested = false,
    this.tags = const [],
    this.added = false,
  });
  final String title;
  final double amount;
  final double? balance;
  final IconData icon;
  final Color color;
  final bool nested;
  final List<TxTag> tags;
  final bool added; // true when the user added it in the app
}

class CategorySpend {
  const CategorySpend({
    required this.title,
    required this.amount,
    required this.percent,
    required this.trend,
    required this.color,
    required this.icon,
  });
  final String title;
  final double amount;
  final double percent; // share of total, e.g. 31 or 24.8
  final int trend; // vs last month, in %
  final Color color;
  final IconData icon;
}

class GoalItem {
  const GoalItem({
    required this.title,
    required this.saved,
    required this.target,
    required this.left,
    required this.progress,
    required this.expected,
    required this.icon,
    this.warning = '',
  });
  final String title;
  final double saved;
  final double target;
  final double left;
  final double progress; // 0..1 filled part of the bar
  final double expected; // 0..1 hatched part (where you should be)
  final IconData icon;
  final String warning;
}

class BudgetItem {
  const BudgetItem({
    required this.title,
    required this.current,
    required this.target,
    required this.percent,
    required this.icon,
    required this.color,
  });
  final String title;
  final double current;
  final double target;
  final int percent;
  final IconData icon;
  final Color color;

  BudgetItem addSaved(double amount) {
    final next = current + amount;
    return BudgetItem(
      title: title,
      current: next,
      target: target,
      percent: (next / target * 100).round().clamp(0, 100).toInt(),
      icon: icon,
      color: color,
    );
  }
}

// ---- Sample data that matches the screenshot ----

const demoTransactions = [
  MoneyTransaction(
    title: 'Cash, EUR',
    amount: 354.25,
    balance: 4245.21,
    icon: Icons.account_balance_wallet_rounded,
    color: LightColors.purpleDark,
    nested: true,
    tags: [TxTag(Icons.credit_card_rounded, 'Red Card', LightColors.red)],
  ),
  MoneyTransaction(
    title: 'Cafes',
    amount: 12.49,
    icon: Icons.local_cafe_rounded,
    color: LightColors.blue,
    tags: [
      TxTag(Icons.sell_rounded, 'Vacation', LightColors.blue),
      TxTag(Icons.person_rounded, 'User Holdings', LightColors.green),
    ],
  ),
];

const expenseCategories = [
  CategorySpend(
    title: 'Groceries',
    amount: 8750.00,
    percent: 31,
    trend: 12,
    color: LightColors.blue,
    icon: Icons.hexagon_outlined,
  ),
  CategorySpend(
    title: 'Clothing & Shoes',
    amount: 6420.35,
    percent: 24.8,
    trend: 6,
    color: LightColors.orange,
    icon: Icons.hexagon_outlined,
  ),
];

const incomeCategories = [
  CategorySpend(
    title: 'Salary',
    amount: 3900.00,
    percent: 80,
    trend: 4,
    color: LightColors.purple,
    icon: Icons.hexagon_outlined,
  ),
  CategorySpend(
    title: 'Freelance',
    amount: 975.12,
    percent: 20,
    trend: 9,
    color: LightColors.blue,
    icon: Icons.hexagon_outlined,
  ),
];

const demoGoal = GoalItem(
  title: 'House by the Sea',
  saved: 8750,
  target: 1750,
  left: 750,
  progress: 0.30,
  expected: 0.45,
  icon: Icons.holiday_village_rounded,
  warning: "You're 30% behind schedule and off target.",
);

const demoBudgets = [
  BudgetItem(title: 'Save for a Car', current: 2500, target: 7500, percent: 55, icon: Icons.directions_car_rounded, color: LightColors.coral),
  BudgetItem(title: 'Save for Education', current: 500, target: 2500, percent: 25, icon: Icons.school_rounded, color: LightColors.purpleDark),
  BudgetItem(title: 'Vacation fund', current: 750, target: 5000, percent: 65, icon: Icons.beach_access_rounded, color: LightColors.blue),
  BudgetItem(title: 'Health Savings', current: 450, target: 1000, percent: 45, icon: Icons.health_and_safety_rounded, color: LightColors.green),
];