import 'package:flutter/material.dart';
import '../../models/light_plan_model.dart';
import '../../state/light_store.dart';
import '../../theme/light_theme.dart';

/// Returns true when an expense was saved.
Future<bool?> showAddTransactionSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => Theme(data: LightTheme.data, child: const _AddTransactionSheet()),
  );
}

class _Cat {
  const _Cat(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

const _cats = [
  _Cat('Food', Icons.lunch_dining_rounded, LightColors.orange),
  _Cat('Groceries', Icons.shopping_cart_rounded, LightColors.green),
  _Cat('Travel', Icons.flight_takeoff_rounded, LightColors.blue),
  _Cat('Leisure', Icons.movie_rounded, LightColors.purpleDark),
  _Cat('Bills', Icons.receipt_long_rounded, LightColors.coral),
  _Cat('Health', Icons.favorite_rounded, LightColors.red),
];

class _AddTransactionSheet extends StatefulWidget {
  const _AddTransactionSheet();

  @override
  State<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<_AddTransactionSheet> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  int _cat = 0;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    final title = _title.text.trim();
    final amount = double.tryParse(_amount.text.replaceAll(',', '').replaceAll('\$', '').trim());
    if (title.isEmpty) {
      setState(() => _error = 'Enter a name for this expense.');
      return;
    }
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter an amount greater than 0.');
      return;
    }
    final c = _cats[_cat];
    LightStore.instance.addExpense(
      MoneyTransaction(
        title: title,
        amount: amount,
        icon: c.icon,
        color: c.color,
        added: true,
        tags: [TxTag(Icons.sell_rounded, c.label, c.color)],
      ),
    );
    Navigator.pop(context, true);
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: LightColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: LightColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Add expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: _decoration('Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => _save(),
              decoration: _decoration('Amount (\$)'),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _cats.length; i++)
                  ChoiceChip(
                    label: Text(_cats[i].label),
                    avatar: Icon(_cats[i].icon, size: 16, color: _cats[i].color),
                    selected: _cat == i,
                    showCheckmark: false,
                    selectedColor: LightColors.purpleSoft,
                    onSelected: (_) => setState(() => _cat = i),
                  ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: LightColors.red, fontSize: 12)),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: LightColors.purple,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save expense', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}