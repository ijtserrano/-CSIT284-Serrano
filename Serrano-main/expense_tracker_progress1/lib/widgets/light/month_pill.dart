import 'package:flutter/material.dart';
import '../../state/light_store.dart';
import '../../theme/light_theme.dart';

const _months = [
  'September 2025',
  'October 2025',
  'November 2025',
  'December 2025',
  'January 2026',
  'February 2026',
];

Future<void> showMonthPicker(BuildContext context) {
  final store = LightStore.instance;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => Theme(
      data: LightTheme.data,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Select month', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            for (final m in _months)
              ListTile(
                title: Text(m),
                trailing: m == store.month.value
                    ? const Icon(Icons.check_rounded, color: LightColors.purple)
                    : null,
                onTap: () {
                  store.month.value = m;
                  Navigator.pop(sheetContext);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

class MonthPill extends StatelessWidget {
  const MonthPill({super.key, this.onDark = false});
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final fg = onDark ? Colors.white : LightColors.ink;
    return ValueListenableBuilder<String>(
      valueListenable: LightStore.instance.month,
      builder: (context, label, _) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => showMonthPicker(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: onDark ? Colors.white.withValues(alpha: 0.2) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: onDark ? null : Border.all(color: LightColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg)),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}