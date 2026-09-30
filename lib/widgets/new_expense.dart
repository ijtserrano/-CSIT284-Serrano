import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../models/money.dart';
import '../theme/app_theme.dart';

/// Bottom sheet for adding a new expense, or editing [existing] if given.
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onSave, this.existing});

  final void Function(Expense expense) onSave;
  final Expense? existing;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  DateTime? _selectedDate;
  Category _category = Category.leisure;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleController = TextEditingController(text: e?.title ?? '');
    _amountController = TextEditingController(
        text: e == null ? '' : (e.cents / 100).toStringAsFixed(2));
    _selectedDate = e?.date;
    _category = e?.category ?? Category.leisure;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit() {
    final title = _titleController.text.trim();
    final cents = parseAmountToCents(_amountController.text);
    final date = _selectedDate;

    if (title.isEmpty || cents == null || date == null) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.error_outline),
          title: const Text('Invalid input'),
          content: const Text(
              'Please enter a title, a positive amount and choose a date.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx), child: const Text('Okay')),
          ],
        ),
      );
      return;
    }

    final existing = widget.existing;
    widget.onSave(existing == null
        ? Expense(title: title, cents: cents, date: date, category: _category)
        : existing.copyWith(
            title: title, cents: cents, date: date, category: _category));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 4, 20, keyboard + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_isEditing ? 'Edit expense' : 'New expense',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            maxLength: 50,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      prefixText: '$currencySymbol ', labelText: 'Amount'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(_selectedDate == null
                      ? 'Pick date'
                      : DateFormat.yMMMd().format(_selectedDate!)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Category>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items: [
              for (final c in Category.values)
                DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Icon(categoryIcons[c],
                          size: 20, color: AppColors.categoryColors[c]),
                      const SizedBox(width: 12),
                      Text(c.label),
                    ],
                  ),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _category = value);
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Save expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}