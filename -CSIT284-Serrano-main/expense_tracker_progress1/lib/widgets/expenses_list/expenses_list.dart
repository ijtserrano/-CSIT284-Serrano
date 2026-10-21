import 'package:flutter/material.dart';

import '../../models/expense.dart';
import '../../theme/app_dimens.dart';
import '../common/slide_fade_in.dart';
import 'expense_item.dart';
import 'swipe_delete_background.dart';

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
  late final Set<String> _seen;

  @override
  void initState() {
    super.initState();
    _seen = {for (final e in widget.expenses) e.id};
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: AppSpacing.fabClearance),
      sliver: SliverList.builder(
        itemCount: widget.expenses.length,
        itemBuilder: (context, i) {
          final e = widget.expenses[i];
          final animate = _seen.add(e.id);

          return SlideFadeIn(
            key: ValueKey(e.id),
            animate: animate,
            child: Dismissible(
              key: ValueKey('dismiss-${e.id}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => widget.onRemoveExpense(e),
              background: const SwipeDeleteBackground(),
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