import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/light_plan_model.dart';
import '../theme/light_theme.dart';
import '../widgets/light/amount_text.dart';
import '../widgets/light/donut_chart.dart';
import '../widgets/light/light_card.dart';
import '../widgets/light/month_pill.dart';

class LightReportScreen extends StatefulWidget {
  const LightReportScreen({super.key, this.onBack});
  final VoidCallback? onBack;

  @override
  State<LightReportScreen> createState() => _LightReportScreenState();
}

class _LightReportScreenState extends State<LightReportScreen> {
  int _tab = 0; // 0 = Expenses, 1 = Income
  bool _donut = true;

  static const _expenseSegments = [
    DonutSegment(fraction: 0.31, color: LightColors.purple),
    DonutSegment(fraction: 0.25, color: LightColors.blue),
    DonutSegment(fraction: 0.22, color: LightColors.green),
    DonutSegment(fraction: 0.14, color: LightColors.orange),
    DonutSegment(fraction: 0.08, color: LightColors.muted, hatched: true),
  ];
  static const _incomeSegments = [
    DonutSegment(fraction: 0.8, color: LightColors.purple),
    DonutSegment(fraction: 0.2, color: LightColors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final isExpense = _tab == 0;
    final segments = isExpense ? _expenseSegments : _incomeSegments;
    final total = isExpense ? 42124.67 : 4875.12;
    final categories = isExpense ? expenseCategories : incomeCategories;
    final label = isExpense ? 'Expenses' : 'Income';
    final chartSize = math.min(270.0, MediaQuery.sizeOf(context).width - 64);

    return ColoredBox(
      color: LightColors.background,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, pad.top + 8, 16, pad.bottom + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'Report',
              onBack: widget.onBack,
              trailing: const MonthPill(),
            ),
            const SizedBox(height: 16),
            _SegmentedToggle(
              labels: const ['Expenses', 'Income'],
              selected: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('$label Report', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const Spacer(),
                _ChartModeSwitch(donut: _donut, onChanged: (v) => setState(() => _donut = v)),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _donut
                    ? DonutChart(
                        key: ValueKey('donut$_tab'),
                        segments: segments,
                        size: chartSize,
                        center: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Total $label', style: const TextStyle(fontSize: 13, color: LightColors.muted)),
                            const SizedBox(height: 4),
                            AmountText(total, size: 26, centsColor: LightColors.muted),
                          ],
                        ),
                      )
                    : _BarChart(key: ValueKey('bars$_tab'), segments: segments, size: chartSize),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All $label', style: const TextStyle(fontSize: 13, color: LightColors.muted)),
                Row(
                  children: [
                    const Text('Total ', style: TextStyle(fontSize: 12, color: LightColors.muted)),
                    AmountText(total, size: 14, weight: FontWeight.w700),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final c in categories)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CategoryTile(c),
              ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  const _SegmentedToggle({required this.labels, required this.selected, required this.onChanged});
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFEDEDEF), borderRadius: BorderRadius.circular(24)),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: selected == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 1 / labels.length,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(i),
                    child: Center(
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: i == selected ? LightColors.ink : LightColors.muted,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartModeSwitch extends StatelessWidget {
  const _ChartModeSwitch({required this.donut, required this.onChanged});
  final bool donut;
  final ValueChanged<bool> onChanged;

  Widget _btn(IconData icon, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? LightColors.purple : Colors.transparent,
        ),
        child: Icon(icon, size: 17, color: active ? Colors.white : LightColors.muted),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LightColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.bar_chart_rounded, !donut, () => onChanged(false)),
          _btn(Icons.donut_large_rounded, donut, () => onChanged(true)),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({super.key, required this.segments, required this.size});
  final List<DonutSegment> segments;
  final double size;

  @override
  Widget build(BuildContext context) {
    final maxF = segments.map((s) => s.fraction).reduce((a, b) => math.max(a, b));
    return SizedBox(
      width: size,
      height: size,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final s in segments)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${(s.fraction * 100).round()}%',
                      style: const TextStyle(fontSize: 11, color: LightColors.muted),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: (size - 30) * s.fraction / maxF,
                      decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(12)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile(this.c);
  final CategorySpend c;

  String get _percent => c.percent == c.percent.roundToDouble()
      ? c.percent.toStringAsFixed(0)
      : c.percent.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final up = c.trend >= 0;
    final trendColor = up ? LightColors.green : LightColors.red;
    return LightCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        children: [
          Row(
            children: [
              SoftIconBox(icon: c.icon, color: c.color, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('$_percent% of total', style: const TextStyle(fontSize: 11, color: LightColors.muted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AmountText(c.amount, size: 14),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: trendColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${up ? '+' : ''}${c.trend}%',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: trendColor),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('vs last month', style: TextStyle(fontSize: 10, color: LightColors.muted)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: c.percent / 100,
              minHeight: 6,
              color: c.color,
              backgroundColor: c.color.withValues(alpha: 0.14),
            ),
          ),
        ],
      ),
    );
  }
}