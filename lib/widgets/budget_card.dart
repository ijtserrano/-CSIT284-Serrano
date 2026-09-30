import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/money.dart';
import '../theme/app_theme.dart';

/// `cents == null` means "remove the budget".
typedef BudgetChoice = ({int? cents});

class BudgetCard extends StatelessWidget {
  const BudgetCard({
    super.key,
    required this.spentCents,
    required this.budgetCents,
    required this.onTap,
  });

  final int spentCents;
  final int? budgetCents;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final budget = budgetCents;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (budget == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.flag_outlined),
          label: const Text('Set monthly budget'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      );
    }

    final ratio = spentCents / budget;
    final over = spentCents > budget;
    final color = over
        ? scheme.error
        : ratio >= 0.8
            ? AppColors.coral
            : scheme.primary;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Monthly budget', style: text.titleMedium),
                  const Spacer(),
                  const Icon(Icons.edit_outlined, size: 18),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: ratio.clamp(0.0, 1.0),
                  minHeight: 10,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15),
                  semanticsLabel: 'Budget used',
                  semanticsValue: '${(ratio * 100).round()} percent',
                ),
              ),
              const SizedBox(height: 8),
              Text('${formatMoney(spentCents)} of ${formatMoney(budget)} this month',
                  style: text.bodyMedium),
              Text(
                over
                    ? 'Over budget by ${formatMoney(spentCents - budget)}'
                    : '${formatMoney(budget - spentCents)} left',
                style: text.bodySmall
                    ?.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BudgetDialog extends StatefulWidget {
  const BudgetDialog({super.key, this.initialCents});

  final int? initialCents;

  @override
  State<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  late final TextEditingController _controller = TextEditingController(
      text: widget.initialCents == null
          ? ''
          : (widget.initialCents! / 100).toStringAsFixed(2));
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final cents = parseAmountToCents(_controller.text);
    if (cents == null) {
      setState(() => _error = 'Enter a positive amount, e.g. 500');
      return;
    }
    Navigator.pop<BudgetChoice>(context, (cents: cents));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Monthly budget'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          prefixText: '$currencySymbol ',
          labelText: 'Amount per month',
          errorText: _error,
        ),
      ),
      actions: [
        if (widget.initialCents != null)
          TextButton(
            onPressed: () =>
                Navigator.pop<BudgetChoice>(context, (cents: null)),
            child: const Text('Remove'),
          ),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}