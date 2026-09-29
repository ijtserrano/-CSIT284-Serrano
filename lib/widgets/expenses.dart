import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'chart/chart.dart';
import '../theme/app_theme.dart';
import 'expenses_list/expenses_list.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense e) => setState(() => _registeredExpenses.add(e));

  void _removeExpense(Expense e) {
    final index = _registeredExpenses.indexOf(e);
    setState(() => _registeredExpenses.remove(e));
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text('"${e.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _registeredExpenses.insert(index, e)),
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _registeredExpenses.isEmpty
        ? const _EmptyState(key: ValueKey('empty'))
        : ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense, key: const ValueKey('list')),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  RotationTransition(turns: anim, child: child),
              child: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(isDark)),
            ),
            onPressed: () => themeModeNotifier.value =
                isDark ? ThemeMode.light : ThemeMode.dark,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          // Wide screens (web / landscape): chart beside the list.
          if (c.maxWidth >= 700) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: list),
              ],
            );
          }
          return Column(children: [Chart(expenses: _registeredExpenses), Expanded(child: list)]);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.savings_outlined,
              size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text('No expenses yet', style: Theme.of(context).textTheme.titleLarge),
          const Text('Tap + to add your first one.'),
        ],
      ),
    );
  }
}
