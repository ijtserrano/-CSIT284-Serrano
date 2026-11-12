import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: expenses.length,
      itemBuilder: (context, i) => _SlideFadeIn(
        key: ValueKey(expenses[i].id),
        child: Dismissible(
          key: ValueKey('dismiss-${expenses[i].id}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onRemoveExpense(expenses[i]),
          background: Container(
            margin: Theme.of(context).cardTheme.margin,
            padding: const EdgeInsets.only(right: 24),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
          ),
          child: ExpenseItem(expenses[i]),
        ),
      ),
    );
  }
}

/// Entrance animation: each new card fades in while sliding up.
class _SlideFadeIn extends StatelessWidget {
  const _SlideFadeIn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 24 * (1 - v)), child: child),
      ),
      child: child,
    );
  }
}
