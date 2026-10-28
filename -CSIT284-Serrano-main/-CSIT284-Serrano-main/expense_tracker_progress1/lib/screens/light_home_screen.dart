import 'package:flutter/material.dart';
import '../models/light_plan_model.dart';
import '../state/light_store.dart';
import '../theme/light_theme.dart';
import '../widgets/light/amount_text.dart';
import '../widgets/light/light_card.dart';
import '../widgets/light/month_pill.dart';

class LightHomeScreen extends StatelessWidget {
  const LightHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final store = LightStore.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([store.transactions, store.month, store.unread]),
      builder: (context, _) => ColoredBox(
        color: LightColors.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(topInset: pad.top),
              // The white sheet overlaps the purple header by 28px.
              Transform.translate(
                offset: const Offset(0, -28),
                child: _Sheet(bottomInset: pad.bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.topInset});
  final double topInset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 52),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LightColors.purple, LightColors.purpleLight],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _Avatar(),
              const MonthPill(onDark: true),
              const _BellButton(),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'Current Balance',
            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.75)),
          ),
          const SizedBox(height: 6),
          AmountText(
            LightStore.instance.balance,
            size: 44,
            color: Colors.white,
            centsColor: Colors.white.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '+\$784 than last week',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFFF2C48D),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 26),
          ),
          Positioned(
            left: -2,
            bottom: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: LightColors.purpleDark,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.star_rounded, color: Colors.white, size: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton();

  @override
  Widget build(BuildContext context) {
    final store = LightStore.instance;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final hadUnread = store.unread.value;
        store.unread.value = false;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                hadUnread ? 'Insight: you are on track with your budgets this month.' : 'No new notifications.',
              ),
            ),
          );
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
            if (store.unread.value)
              Positioned(
                top: 11,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Color(0xFFFF3B30), shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.bottomInset});
  final double bottomInset;

  static String _signed(double v) => '${v < 0 ? '-' : ''}\$${v.abs().toStringAsFixed(2)}';

  static Widget _detailRow(String label, double v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(_signed(v), style: const TextStyle(fontWeight: FontWeight.w600))],
        ),
      );

  void _showDetails(BuildContext context) {
    final store = LightStore.instance;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Theme(
        data: LightTheme.data,
        child: AlertDialog(
          title: Text(store.month.value),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Income', LightStore.income),
              _detailRow('Expenses', store.expenses),
              const Divider(),
              _detailRow('Net', LightStore.income - store.expenses),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Close')),
          ],
        ),
      ),
    );
  }

  void _showInsight(BuildContext context, List<MoneyTransaction> items) {
    String msg;
    if (items.isEmpty) {
      msg = 'Add an expense to get an insight.';
    } else {
      final top = items.reduce((a, b) => a.amount >= b.amount ? a : b);
      msg = 'Biggest expense: ${top.title} (\$${top.amount.toStringAsFixed(2)}).';
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final store = LightStore.instance;
    final items = store.transactions.value;
    final listed = items.fold<double>(0, (sum, t) => sum + t.amount);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 22, 16, bottomInset + 24),
      decoration: const BoxDecoration(
        color: LightColors.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('Your Money', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(width: 6),
                  Icon(Icons.info_outline_rounded, size: 16, color: LightColors.muted),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _showDetails(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: LightColors.border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      Icon(Icons.chevron_right_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: _MoneyCard(
                  label: 'Income',
                  value: LightStore.income,
                  icon: Icons.savings_rounded,
                  color: LightColors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MoneyCard(
                  label: 'Expenses',
                  value: store.expenses,
                  icon: Icons.account_balance_wallet_rounded,
                  color: LightColors.coral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => _showInsight(context, items),
            child: const _InsightBanner(),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Text('Transactions', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const Spacer(),
              const _RoundIcon(Icons.push_pin_outlined),
              const SizedBox(width: 8),
              const _RoundIcon(Icons.history_rounded),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: LightColors.purpleSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'For the Period',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: LightColors.purpleDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Monday, 12 January, 2026', style: TextStyle(fontSize: 12, color: LightColors.muted)),
              Row(
                children: [
                  const Text('Total ', style: TextStyle(fontSize: 12, color: LightColors.muted)),
                  AmountText(listed, size: 14, weight: FontWeight.w700),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No transactions yet. Tap + to add one.',
                    style: TextStyle(fontSize: 12, color: LightColors.muted)),
              ),
            ),
          for (final t in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Dismissible(
                key: ObjectKey(t),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 22),
                  decoration: BoxDecoration(
                    color: LightColors.red,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                ),
                onDismissed: (_) {
                  final index = items.indexOf(t);
                  store.remove(t);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('${t.title} deleted'),
                        action: SnackBarAction(label: 'Undo', onPressed: () => store.restore(t, index)),
                      ),
                    );
                },
                child: _TransactionTile(t),
              ),
            ),
        ],
      ),
    );
  }
}

class _MoneyCard extends StatelessWidget {
  const _MoneyCard({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final double value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoftIconBox(icon: icon, color: color, size: 40, circle: true),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: LightColors.muted)),
              const SizedBox(width: 4),
              const Icon(Icons.info_outline_rounded, size: 13, color: LightColors.muted),
            ],
          ),
          const SizedBox(height: 4),
          AmountText(value, size: 20),
        ],
      ),
    );
  }
}

class _InsightBanner extends StatelessWidget {
  const _InsightBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: LightColors.purple.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: LightColors.purpleLight, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your insight is ready',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Text('Get Pro', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: LightColors.border),
      ),
      child: Icon(icon, size: 16, color: LightColors.muted),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile(this.t);
  final MoneyTransaction t;

  @override
  Widget build(BuildContext context) {
    return LightCard(
      padding: const EdgeInsets.all(12),
      radius: 18,
      child: Row(
        children: [
          SoftIconBox(icon: t.icon, color: t.color, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (t.nested)
                      const Icon(Icons.subdirectory_arrow_right_rounded, size: 14, color: LightColors.muted),
                    for (final tag in t.tags)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tag.icon, size: 12, color: tag.color),
                          const SizedBox(width: 3),
                          Text(tag.label, style: const TextStyle(fontSize: 11, color: LightColors.muted)),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-${t.amount.toStringAsFixed(2)}\$',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: LightColors.red),
              ),
              if (t.balance != null) ...[
                const SizedBox(height: 2),
                AmountText(t.balance!, size: 12, weight: FontWeight.w400, color: LightColors.muted),
              ],
            ],
          ),
        ],
      ),
    );
  }
}