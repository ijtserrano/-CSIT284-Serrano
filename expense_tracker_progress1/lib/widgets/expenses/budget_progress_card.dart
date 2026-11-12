import 'package:flutter/material.dart';

class BudgetProgressCard extends StatelessWidget {
  final double currentSpending;
  final double budgetLimit;

  const BudgetProgressCard({
    super.key,
    required this.currentSpending,
    required this.budgetLimit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentSpending / budgetLimit).clamp(0.0, 1.0);
    final percentText = (progress * 100).toStringAsFixed(0);
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Monthly Target",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  "$percentText% used",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: progress > 0.85 ? Colors.redAccent : theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.85 ? Colors.redAccent : theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}