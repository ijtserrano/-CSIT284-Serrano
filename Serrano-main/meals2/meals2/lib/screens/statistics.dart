import 'package:flutter/material.dart';
import 'package:meals2/data/dummy_data.dart';
import 'package:meals2/providers/favorites_store.dart';
import 'package:meals2/providers/quiz_stats_store.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  Widget _statCard(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Text(value, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }

  String _date(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            tooltip: 'Clear quiz history',
            icon: const Icon(Icons.delete_outline),
            onPressed: quizStatsStore.clear,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([quizStatsStore, favoritesStore]),
        builder: (context, _) {
          final attempts = quizStatsStore.attempts;
          final average = attempts.isEmpty
              ? 0
              : attempts.map((a) => a.percent).reduce((a, b) => a + b) /
                  attempts.length;
          final best = attempts.isEmpty
              ? 0
              : attempts.map((a) => a.percent).reduce((a, b) => a > b ? a : b);

          // Best score per category.
          final bestByCategory = <String, double>{};
          for (final a in attempts) {
            final current = bestByCategory[a.categoryTitle] ?? 0;
            if (a.percent >= current) bestByCategory[a.categoryTitle] = a.percent;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Quizzes', style: theme.textTheme.titleLarge),
              Row(
                children: [
                  _statCard(context, 'Taken', '${attempts.length}'),
                  _statCard(context, 'Average', '${average.round()}%'),
                  _statCard(context, 'Best', '${best.round()}%'),
                ],
              ),
              const SizedBox(height: 16),
              Text('App', style: theme.textTheme.titleLarge),
              Row(
                children: [
                  _statCard(context, 'Meals', '${dummyMeals.length}'),
                  _statCard(
                      context, 'Categories', '${availableCategories.length}'),
                  _statCard(
                      context, 'Favorites', '${favoritesStore.meals.length}'),
                ],
              ),
              if (bestByCategory.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Best score by category', style: theme.textTheme.titleLarge),
                for (final entry in bestByCategory.entries)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.key),
                    subtitle: LinearProgressIndicator(value: entry.value / 100),
                    trailing: Text('${entry.value.round()}%'),
                  ),
              ],
              const SizedBox(height: 16),
              Text('Recent attempts', style: theme.textTheme.titleLarge),
              if (attempts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No quizzes taken yet. Try one from the menu!'),
                ),
              for (final a in attempts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.quiz),
                  title: Text(a.categoryTitle),
                  subtitle: Text(_date(a.date)),
                  trailing: Text('${a.score}/${a.total}'),
                ),
            ],
          );
        },
      ),
    );
  }
}