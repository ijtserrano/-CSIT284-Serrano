import 'package:flutter/material.dart';
import '../models/light_plan_model.dart';
import '../state/light_store.dart';
import '../theme/light_theme.dart';
import '../widgets/light/goal_progress_bar.dart';
import '../widgets/light/light_card.dart';
import '../widgets/light/progress_ring.dart';

class LightPlanScreen extends StatelessWidget {
  const LightPlanScreen({super.key, this.onBack});
  final VoidCallback? onBack;

  void _showAddBudgetDialog(BuildContext context) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Budget name',
              ),
            ),
            TextField(
              controller: targetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Target amount',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              final target =
                  double.tryParse(targetController.text.trim());

              if (title.isEmpty || target == null || target <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a name and a valid target.'),
                  ),
                );
                return;
              }

              final store = LightStore.instance;
              final updated = [...store.budgets.value];

              updated.add(
                BudgetItem(
                  title: title,
                  current: 0,
                  target: target,
                  percent: 0,
                  icon: Icons.savings_rounded,
                  color: LightColors.purple,
                ),
              );

              store.budgets.value = updated;
              Navigator.pop(dialogContext);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title budget added.')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).whenComplete(() {
      titleController.dispose();
      targetController.dispose();
    });
  }

  void _showBudgetSummary(BuildContext context) {
    final budgets = LightStore.instance.budgets.value;

    final totalSaved = budgets.fold<double>(
      0,
      (sum, budget) => sum + budget.current,
    );

    final totalTarget = budgets.fold<double>(
      0,
      (sum, budget) => sum + budget.target,
    );

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Budget Summary'),
        content: Text(
          'Total saved: \$${totalSaved.toStringAsFixed(2)}\n'
          'Total target: \$${totalTarget.toStringAsFixed(2)}\n'
          'Remaining: \$${(totalTarget - totalSaved).toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return ColoredBox(
      color: LightColors.background,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, pad.top + 8, 16, pad.bottom + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'My Plan',
              onBack: onBack,
              trailing: Row(
                children: [
                  _CircleButton(
                    icon: Icons.add_rounded,
                    filled: true,
                    onTap: () => _showAddBudgetDialog(context),
                  ),
                  const SizedBox(width: 8),
                  _CircleButton(
                    icon: Icons.north_east_rounded,
                    filled: false,
                    onTap: () => _showBudgetSummary(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SectionTitle('Goals'),
            const SizedBox(height: 12),
            const _GoalCard(demoGoal),
            const SizedBox(height: 22),
            const _SectionTitle('Budgets'),
            const SizedBox(height: 4),
            const Text('Tap a budget to add up to \$100', style: TextStyle(fontSize: 11, color: LightColors.muted)),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<BudgetItem>>(
              valueListenable: LightStore.instance.budgets,
              builder: (context, budgets, _) => Column(
                children: [
                  for (var i = 0; i < budgets.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          final store = LightStore.instance;
                          final budget = store.budgets.value[i];

                          if (budget.current >= budget.target) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${budget.title} has reached its target.'),
                              ),
                            );
                            return;
                          }

                          final amount = (budget.target - budget.current)
                              .clamp(0.0, 100.0)
                              .toDouble();

                          store.addToBudget(i, amount);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added \$${amount.toStringAsFixed(2)} to ${budget.title}',
                              ),
                            ),
                          );
                        },
                        child: _BudgetTile(budgets[i]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(
    this.title) : onViewAll = null;

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: onViewAll ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Viewing all $title')),
                );
              },
          child: const Text('View All'),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? LightColors.ink : Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: filled
                ? null
                : Border.all(color: LightColors.border),
          ),
          child: Icon(
            icon,
            size: 20,
            color: filled ? Colors.white : LightColors.ink,
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard(this.g);
  final GoalItem g;

  String _money(double v) {
    final s = v.toStringAsFixed(2);
    final whole = s.split('.').first.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
    return '\$$whole.${s.split('.').last}';
  } 

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LightColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SoftIconBox(icon: g.icon, color: LightColors.coral),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          const Text('View All', style: TextStyle(fontSize: 12, color: LightColors.muted)),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(color: Color(0xFFF4F4F6), shape: BoxShape.circle),
                      child: const Icon(Icons.more_vert_rounded, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text.rich(
                  TextSpan(
                    text: _money(g.saved),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: LightColors.ink),
                    children: [
                      TextSpan(
                        text: '  Out of ${_money(g.target)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: LightColors.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                GoalProgressBar(progress: g.progress, expected: g.expected),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Your Progress', style: TextStyle(fontSize: 11, color: LightColors.muted)),
                    Text(
                      '\$${g.left.toStringAsFixed(0)} Left',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (g.warning.isNotEmpty)
            Container(
              width: double.infinity,
              color: LightColors.coral,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.info_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      g.warning,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BudgetTile extends StatelessWidget {
  const _BudgetTile(this.b);
  final BudgetItem b;

  @override
  Widget build(BuildContext context) {
    return LightCard(
      padding: const EdgeInsets.all(12),
      radius: 18,
      child: Row(
        children: [
          SoftIconBox(icon: b.icon, color: b.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    text: '\$${b.current.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: LightColors.ink),
                    children: [
                      TextSpan(
                        text: ' of \$${b.target.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: LightColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ProgressRing(percent: b.percent, color: b.color),
        ],
      ),
    );
  }
}