import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../data/expense_repository.dart';
import '../models/expense.dart';

enum Period { allTime, thisMonth }

/// Holds expense state, keeps it sorted (newest first), filters it and
/// persists changes.
class ExpenseController extends ChangeNotifier {
  ExpenseController(this._repo);

  final ExpenseRepository _repo;
  final List<Expense> _all = [];

  bool loaded = false;
  Period period = Period.allTime;
  String query = '';
  Category? categoryFilter;
  int? budgetCents;

  bool get hasAny => _all.isNotEmpty;
  bool get filtersActive => query.trim().isNotEmpty || categoryFilter != null;
  List<Expense> get all => List.unmodifiable(_all);

  Iterable<Expense> _periodAndQuery() {
    final now = DateTime.now();
    final q = query.trim().toLowerCase();
    return _all.where((e) {
      if (period == Period.thisMonth &&
          !(e.date.year == now.year && e.date.month == now.month)) {
        return false;
      }
      return q.isEmpty || e.title.toLowerCase().contains(q);
    });
  }

  /// What the chart shows: period + search (not the category chip, so the
  /// chart still compares all categories).
  List<Expense> get chartExpenses => List.unmodifiable(_periodAndQuery());

  /// What the list shows: period + search + category.
  List<Expense> get visible => List.unmodifiable(_periodAndQuery()
      .where((e) => categoryFilter == null || e.category == categoryFilter));

  /// Spent in the current calendar month (independent of filters).
  int get monthSpentCents {
    final now = DateTime.now();
    return _all
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0, (sum, e) => sum + e.cents);
  }

  Future<void> load() async {
    _all
      ..clear()
      ..addAll(await _repo.load());
    budgetCents = await _repo.loadBudget();
    _sort();
    loaded = true;
    notifyListeners();
  }

  void setPeriod(Period p) {
    period = p;
    notifyListeners();
  }

  void setQuery(String q) {
    query = q;
    notifyListeners();
  }

  void setCategoryFilter(Category? c) {
    categoryFilter = c;
    notifyListeners();
  }

  Future<void> setBudget(int? cents) async {
    budgetCents = cents;
    notifyListeners();
    await _repo.saveBudget(cents);
  }

  /// Also used for "Undo": sorting puts a restored expense back in place.
  Future<void> add(Expense e) async {
    _all.add(e);
    await _changed();
  }

  Future<void> update(Expense e) async {
    final i = _all.indexWhere((x) => x.id == e.id);
    if (i == -1) return;
    _all[i] = e;
    await _changed();
  }

  Future<void> remove(Expense e) async {
    _all.removeWhere((x) => x.id == e.id);
    await _changed();
  }

  /// Adds expenses whose id isn't already present. Returns how many were added.
  Future<int> importAll(List<Expense> items) async {
    final ids = {for (final e in _all) e.id};
    final fresh = items.where((e) => ids.add(e.id)).toList();
    if (fresh.isEmpty) return 0;
    _all.addAll(fresh);
    await _changed();
    return fresh.length;
  }

  Future<void> _changed() async {
    _sort();
    notifyListeners();
    await _repo.save(_all);
  }

  void _sort() => _all.sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        return byDate != 0 ? byDate : b.createdAt.compareTo(a.createdAt);
      });
}
