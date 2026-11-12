import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _developerName = 'Ij Cromwell Taban Serrano';
  static const _developerRole = 'BSIT Student & Flutter Developer';
  static const _developerEmail = 'ijcromwell.serrano@cit.edu';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget feature(IconData icon, String text) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(text),
        );
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.fastfood,
                  size: 44, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text('Meals',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium),
          const Text('Version 1.0.0', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          const Text(
            'Browse meals by category, filter by diet, save favorites, '
            'search recipes and test your knowledge with quizzes.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text('Features', style: theme.textTheme.titleLarge),
          feature(Icons.grid_view, 'Category browsing'),
          feature(Icons.tune, 'Diet filters'),
          feature(Icons.star, 'Favorites'),
          feature(Icons.search, 'Search by meal or ingredient'),
          feature(Icons.quiz, 'Category quizzes with results'),
          feature(Icons.bar_chart, 'Statistics'),
          const SizedBox(height: 16),
          Text('Developer', style: theme.textTheme.titleLarge),
          const Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(_developerName),
              subtitle: Text('$_developerRole\n$_developerEmail'),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.description_outlined),
            label: const Text('Open source licenses'),
            onPressed: () => showLicensePage(context: context),
          ),
        ],
      ),
    );
  }
}