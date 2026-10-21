import 'package:flutter/material.dart';

import '../../models/expense.dart';
import '../../models/money.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_theme.dart';
import '../common/category_icon.dart';
import 'chart_bar.dart';

String _dollars(double amount) => formatMoney((amount * 100).round());

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.expenses,
    this.title = 'Total spent',
    this.barHeight = defaultBarHeight,
  });

  static const double defaultBarHeight = 120;

  final List<Expense> expenses;
  final String title;
  final double barHeight;

  List<ExpenseBucket> get buckets => [
        for (final c in Category.values) ExpenseBucket.forCategory(expenses, c),
      ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final data = buckets;
    final total = data.fold(0.0, (s, b) => s + b.totalExpenses);
    final maxTotal =
        data.fold(0.0, (m, b) => b.totalExpenses > m ? b.totalExpenses : m);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.panel),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.30),
            scheme.secondary.withValues(alpha: 0.15),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.labelLarge),
          TweenAnimationBuilder<double>(
            tween: Tween(end: total),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => Text(
              _dollars(v),
              style: textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: barHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final b in data)
                  Expanded(
                    child: Tooltip(
                      message: '${b.category.label}: ${_dollars(b.totalExpenses)}',
                      child: ChartBar(
                        fill: maxTotal == 0 ? 0 : b.totalExpenses / maxTotal,
                        color: AppColors.categoryColors[b.category]!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final b in data)
                Expanded(child: CategoryIcon(b.category)),
            ],
          ),
        ],
      ),
    );
  }
}