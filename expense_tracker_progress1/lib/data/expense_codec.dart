import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class DecodeResult {
  final List<Expense> expenses;
  final int skipped;
  DecodeResult({required this.expenses, required this.skipped});
}

DecodeResult decodeExpenses(String raw) {
  final Object? data;
  try {
    data = jsonDecode(raw);
  } catch (_) {
    return DecodeResult(expenses: <Expense>[], skipped: 1);
  }
  if (data is! List) return DecodeResult(expenses: <Expense>[], skipped: 1);

  final out = <Expense>[];
  var skipped = 0;
  for (final j in data) {
    try {
      out.add(Expense.fromJson(j as Map<String, dynamic>));
    } catch (_) {
      skipped++;
    }
  }
  return DecodeResult(expenses: out, skipped: skipped);
}

String encodeExpenses(List<Expense> list) =>
    jsonEncode([for (final e in list) e.toJson()]);

/// Pretty JSON used for backups (can be re-imported).
String exportJson(List<Expense> list) => const JsonEncoder.withIndent('  ')
    .convert([for (final e in list) e.toJson()]);

/// CSV for spreadsheets. Titles are quoted, and values that could be read as
/// formulas (=, +, -, @) are prefixed with an apostrophe.
String exportCsv(List<Expense> list) {
  final df = DateFormat('yyyy-MM-dd');
  final b = StringBuffer('date,title,category,amount\n');
  for (final e in list) {
    final amount =
        '${e.cents ~/ 100}.${(e.cents % 100).toString().padLeft(2, '0')}';
    b.writeln('${df.format(e.date)},${_csvText(e.title)},${e.category.name},$amount');
  }
  return b.toString();
}

String _csvText(String s) {
  final safe = RegExp(r'^[+\-=@]').hasMatch(s) ? "'$s" : s;
  return '"${safe.replaceAll('"', '""')}"';
}