import 'package:expense_tracker/data/expense_repository.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/state/expense_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Expense _e(String title, DateTime date,
        {int cents = 100, Category category = Category.food}) =>
    Expense(title: title, cents: cents, date: date, category: category);

Future<ExpenseController> _controller() async {
  final c = ExpenseController(const ExpenseRepository());
  await c.load();
  return c;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('keeps expenses sorted newest first', () async {
    final c = await _controller();
    await c.add(_e('old', DateTime(2025, 1, 1)));
    await c.add(_e('new', DateTime(2026, 6, 1)));
    await c.add(_e('mid', DateTime(2026, 1, 1)));
    expect(c.visible.map((e) => e.title).toList(), ['new', 'mid', 'old']);
  });

  test('undo (re-add) restores the expense in its sorted place', () async {
    final c = await _controller();
    final a = _e('a', DateTime(2026, 5, 1));
    await c.add(a);
    await c.add(_e('b', DateTime(2026, 4, 1)));
    await c.remove(a);
    expect(c.visible.length, 1);
    await c.add(a);
    expect(c.visible.first.title, 'a');
  });

  test('update replaces by id', () async {
    final c = await _controller();
    final a = _e('a', DateTime(2026, 5, 1));
    await c.add(a);
    await c.update(a.copyWith(title: 'renamed', cents: 999));
    expect(c.visible.single.title, 'renamed');
    expect(c.visible.single.cents, 999);
  });

  test('data survives a restart (new controller, same storage)', () async {
    final first = await _controller();
    await first.add(_e('persisted', DateTime(2026, 5, 1), cents: 4200));

    final second = await _controller();
    expect(second.visible.single.title, 'persisted');
    expect(second.visible.single.cents, 4200);
  });

  test('this-month filter hides older expenses', () async {
    final c = await _controller();
    await c.add(_e('now', DateTime.now()));
    await c.add(_e('old', DateTime(2020, 1, 1)));
    c.setPeriod(Period.thisMonth);
    expect(c.visible.map((e) => e.title).toList(), ['new', 'mid', 'old']);
    expect(c.hasAny, isTrue);
  });

  test('search is case-insensitive and category chip narrows the list',
      () async {
    final c = await _controller();
    await c.add(_e('Coffee beans', DateTime(2026, 5, 3), category: Category.groceries));
    await c.add(_e('Coffee shop', DateTime(2026, 5, 2)));
    await c.add(_e('Rent', DateTime(2026, 5, 1), category: Category.bills));

    c.setQuery('COFFEE');
    expect(c.visible.length, 2);

    c.setCategoryFilter(Category.groceries);
    expect(c.visible.single.title, 'Coffee beans');
    expect(c.filtersActive, isTrue);

    // Chart ignores the category chip so it still compares categories.
    expect(c.chartExpenses.length, 2);
  });

  test('budget persists; monthly spend counts only the current month', () async {
    final c = await _controller();
    await c.add(_e('now', DateTime.now(), cents: 2500));
    await c.add(_e('old', DateTime(2020, 1, 1), cents: 9999));
    expect(c.monthSpentCents, 2500);

    await c.setBudget(50000);
    final again = await _controller();
    expect(again.budgetCents, 50000);

    await again.setBudget(null);
    expect((await _controller()).budgetCents, isNull);
  });

  test('importAll skips ids that already exist', () async {
    final c = await _controller();
    final a = _e('a', DateTime(2026, 5, 1));
    await c.add(a);
    final added = await c.importAll([a, _e('b', DateTime(2026, 4, 1))]);
    expect(added, 1);
    expect(c.all.length, 2);
  });
}