import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  /// One of: 'meals', 'search', 'filters', 'quiz', 'statistics',
  /// 'settings', 'about'.
  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget tile(IconData icon, String label, String id) => ListTile(
          leading: Icon(icon, size: 26, color: theme.colorScheme.onSurface),
          title: Text(
            label,
            style: theme.textTheme.titleSmall!.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: 22,
            ),
          ),
          onTap: () => onSelectScreen(id),
        );

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.fastfood,
                    size: 48, color: theme.colorScheme.primary),
                const SizedBox(width: 18),
                Text(
                  'Cooking Up!',
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                tile(Icons.restaurant, 'Meals', 'meals'),
                tile(Icons.search, 'Search', 'search'),
                tile(Icons.tune, 'Filters', 'filters'),
                const Divider(),
                tile(Icons.quiz, 'Quiz', 'quiz'),
                tile(Icons.bar_chart, 'Statistics', 'statistics'),
                const Divider(),
                tile(Icons.settings, 'Settings', 'settings'),
                tile(Icons.info_outline, 'About', 'about'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}