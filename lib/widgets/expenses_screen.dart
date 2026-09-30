import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/expense_codec.dart';
import '../data/expense_repository.dart';
import '../models/expense.dart';
import '../state/expense_controller.dart';
import '../theme/app_theme.dart';
import 'budget_card.dart';
import 'chart/chart.dart';
import 'expenses_list/expenses_list.dart';
import 'filter_bar.dart';
import 'new_expense.dart';

enum _MenuAction { copyCsv, copyJson, importJson }

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen(
      {super.key, this.repository = const ExpenseRepository()});

  final ExpenseRepository repository;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late final ExpenseController _controller =
      ExpenseController(widget.repository);

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openSheet({Expense? existing}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => NewExpense(
        existing: existing,
        onSave: (e) => existing == null ? _controller.add(e) : _controller.update(e),
      ),
    );
  }

  void _removeExpense(Expense e) {
    _controller.remove(e);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text('"${e.title}" deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: () => _controller.add(e)),
      ));
  }

  Future<void> _editBudget() async {
    final result = await showDialog<BudgetChoice>(
      context: context,
      builder: (_) => BudgetDialog(initialCents: _controller.budgetCents),
    );
    if (result != null) _controller.setBudget(result.cents);
  }

  Future<void> _handleMenu(_MenuAction action) async {
    switch (action) {
      case _MenuAction.copyCsv:
      case _MenuAction.copyJson:
        final all = _controller.all;
        if (all.isEmpty) {
          _toast('Nothing to export yet');
          return;
        }
        final isCsv = action == _MenuAction.copyCsv;
        await Clipboard.setData(
            ClipboardData(text: isCsv ? exportCsv(all) : exportJson(all)));
        if (!mounted) return;
        _toast('Copied ${all.length} expenses as ${isCsv ? 'CSV' : 'JSON backup'}');
      case _MenuAction.importJson:
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        final result = decodeExpenses(data?.text ?? '');
        if (result.expenses.isEmpty) {
          if (mounted) {
            _toast('Nothing to import: the clipboard has no valid JSON backup');
          }
          return;
        }
        final added = await _controller.importAll(result.expenses);
        if (!mounted) return;
        final existing = result.expenses.length - added;
        _toast('Imported $added new expenses'
            '${existing > 0 ? ', $existing already existed' : ''}'
            '${result.skipped > 0 ? ', ${result.skipped} invalid skipped' : ''}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
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
          PopupMenuButton<_MenuAction>(
            tooltip: 'Export / import',
            onSelected: _handleMenu,
            itemBuilder: (_) => const [
              PopupMenuItem(value: _MenuAction.copyCsv, child: Text('Copy as CSV')),
              PopupMenuItem(
                  value: _MenuAction.copyJson, child: Text('Copy backup (JSON)')),
              PopupMenuItem(
                  value: _MenuAction.importJson,
                  child: Text('Import backup from clipboard')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openSheet(),
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (!_controller.loaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final expenses = _controller.visible;
          final monthly = _controller.period == Period.thisMonth;

          final header = Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: SegmentedButton<Period>(
                segments: const [
                  ButtonSegment(value: Period.allTime, label: Text('All time')),
                  ButtonSegment(
                      value: Period.thisMonth, label: Text('This month')),
                ],
                selected: {_controller.period},
                onSelectionChanged: (s) => _controller.setPeriod(s.first),
              ),
            ),
            BudgetCard(
              spentCents: _controller.monthSpentCents,
              budgetCents: _controller.budgetCents,
              onTap: _editBudget,
            ),
            Chart(
              expenses: _controller.chartExpenses,
              title: monthly ? 'Spent this month' : 'Total spent',
            ),
          ]);

          Widget emptyState() {
            final String title;
            final String subtitle;
            if (!_controller.hasAny) {
              title = 'No expenses yet';
              subtitle = 'Tap "Add expense" to add your first one.';
            } else if (_controller.filtersActive) {
              title = 'No matches';
              subtitle = 'Try a different search, category or period.';
            } else {
              title = 'Nothing this month';
              subtitle = 'Switch to "All time" to see older expenses.';
            }
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 96),
                child: _EmptyState(title: title, subtitle: subtitle),
              ),
            );
          }

          // One scroll view: on phones the chart scrolls away with the list,
          // so nothing overflows when the keyboard is open.
          Widget scrollView({required bool includeHeader}) => CustomScrollView(
                slivers: [
                  if (includeHeader) SliverToBoxAdapter(child: header),
                  SliverToBoxAdapter(
                    child: FilterBar(
                      query: _controller.query,
                      category: _controller.categoryFilter,
                      onQueryChanged: _controller.setQuery,
                      onCategoryChanged: _controller.setCategoryFilter,
                    ),
                  ),
                  if (expenses.isEmpty)
                    emptyState()
                  else
                    ExpensesList(
                      expenses: expenses,
                      onRemoveExpense: _removeExpense,
                      onEditExpense: (e) => _openSheet(existing: e),
                    ),
                ],
              );

          return LayoutBuilder(builder: (context, c) {
            // Wide screens (web / landscape): chart beside the list.
            if (c.maxWidth >= 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SingleChildScrollView(child: header)),
                  Expanded(child: scrollView(includeHeader: false)),
                ],
              );
            }
            return scrollView(includeHeader: true);
          });
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.savings_outlined,
              size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}