import 'package:flutter/material.dart';

import '../../models/expense.dart';
import '../../theme/app_theme.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses, this.title = 'Total spent'});

  final List<Expense> expenses;
  final String title;

  List<ExpenseBucket> get buckets => [
        for (final c in Category.values) ExpenseBucket.forCategory(expenses, c),
      ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final data = buckets;
    final total = data.fold(0.0, (s, b) => s + b.totalExpenses);
    final maxTotal =
        data.fold(0.0, (m, b) => b.totalExpenses > m ? b.totalExpenses : m);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          TweenAnimationBuilder<double>(
            tween: Tween(end: total),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => Text(
              '\$${v.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final b in data)
                  Expanded(
                    child: Tooltip(
                      message:
                          '${b.category.name}: \$${b.totalExpenses.toStringAsFixed(2)}',
                      child: ChartBar(
                        fill: maxTotal == 0 ? 0 : b.totalExpenses / maxTotal,
                        color: AppColors.categoryColors[b.category]!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final b in data)
                Expanded(
                  child: Icon(
                    categoryIcons[b.category],
                    color: AppColors.categoryColors[b.category],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}