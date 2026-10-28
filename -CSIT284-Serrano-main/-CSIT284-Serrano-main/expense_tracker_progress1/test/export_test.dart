import 'package:expense_tracker/data/expense_codec.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CSV quotes titles, escapes quotes and blocks formulas', () {
    final csv = exportCsv([
      Expense(
        title: 'He said "hi"',
        cents: 1250,
        date: DateTime(2026, 3, 5),
        category: Category.food,
      ),
      Expense(
        title: '=SUM(A1)',
        cents: 7,
        date: DateTime(2026, 3, 6),
        category: Category.bills,
      ),
    ]);
    expect(csv, contains('date,title,category,amount'));
    expect(csv, contains('2026-03-05,"He said ""hi""",food,12.50'));
    expect(csv, contains('"\'=SUM(A1)"'));
    expect(csv, contains(',bills,0.07'));
  });

  test('JSON backup round-trips', () {
    final original = [
      Expense(
        title: 'Lunch',
        cents: 1999,
        date: DateTime(2026, 3, 14),
        category: Category.food,
      ),
    ];
    final result = decodeExpenses(exportJson(original));
    expect(result.skipped, 0);
    expect(result.expenses.single.id, original.single.id);
    expect(result.expenses.single.cents, 1999);
  });

  test('a bad record is skipped, the rest still load', () {
    const raw = '''
[
  {"id":"1","title":"ok","cents":100,"date":"2026-01-01T00:00:00.000","category":"food"},
  {"id":"2","title":"bad category","cents":100,"date":"2026-01-01T00:00:00.000","category":"removed"},
  {"oops": true}
]''';
    final result = decodeExpenses(raw);
    expect(result.expenses.map((e) => e.id), ['1']);
    expect(result.skipped, 1);
  });

  test('invalid JSON yields nothing and reports a problem', () {
    expect(decodeExpenses('not json').expenses, isEmpty);
    expect(decodeExpenses('not json').skipped, 1);
    expect(decodeExpenses('{"a":1}').skipped, 1);
    expect(decodeExpenses('').expenses, isEmpty);
  });
}