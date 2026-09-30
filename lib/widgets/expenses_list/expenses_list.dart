import 'package:flutter/material.dart';

import '../../models/expense.dart';
import 'expense_item.dart';

/// A sliver, so it can share one scroll view with the chart and filters.
class ExpensesList extends StatefulWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
    required this.onEditExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense) onRemoveExpense;
  final void Function(Expense) onEditExpense;

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  // Ids already shown once. Only unseen items play the entrance animation, so
  // cards don't re-animate every time they scroll back into view.
  late final Set<String> _seen = {for (final e in widget.expenses) e.id};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 96),
      sliver: SliverList.builder(
        itemCount: widget.expenses.length,
        itemBuilder: (context, i) {
          final e = widget.expenses[i];
          final animate = _seen.add(e.id); // true only the first time
          return _SlideFadeIn(
            key: ValueKey(e.id),
            animate: animate,
            child: Dismissible(
              key: ValueKey('dismiss-${e.id}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => widget.onRemoveExpense(e),
              background: Container(
                margin: theme.cardTheme.margin,
                padding: const EdgeInsets.only(right: 24),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.delete, color: theme.colorScheme.onError),
              ),
              child: ExpenseItem(
                e,
                onEdit: () => widget.onEditExpense(e),
                onDelete: () => widget.onRemoveExpense(e),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Entrance animation: the card fades in while sliding up (if [animate]).
class _SlideFadeIn extends StatefulWidget {
  const _SlideFadeIn(
      {super.key, required this.animate, required this.child});

  final bool animate;
  final Widget child;

  @override
  State<_SlideFadeIn> createState() => _SlideFadeInState();
}

class _SlideFadeInState extends State<_SlideFadeIn> {
  late final double _start = widget.animate ? 0.0 : 1.0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _start, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 24 * (1 - v)), child: child),
      ),
      child: widget.child,
    );
  }
}