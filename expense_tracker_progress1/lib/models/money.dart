import 'package:intl/intl.dart';

const currencySymbol = '\$';

/// 123456 -> "$1,234.56"
String formatMoney(int cents) =>
    '$currencySymbol${NumberFormat('#,##0.00').format(cents / 100)}';

/// "12.5", "12,50" or "1,234.50" -> cents. Returns null if not a positive amount.
int? parseAmountToCents(String input) {
  var s = input.trim().replaceAll(' ', '');
  if (s.isEmpty) return null;
  if (s.contains(',') && s.contains('.')) {
    s = s.replaceAll(',', '');
  } else {
    s = s.replaceAll(',', '.');
  }
  final v = double.tryParse(s);
  if (v == null || !v.isFinite || v <= 0) return null;
  final cents = (v * 100).round();
  return cents > 0 ? cents : null;
}