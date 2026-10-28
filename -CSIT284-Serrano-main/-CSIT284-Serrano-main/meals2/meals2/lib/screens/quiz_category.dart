import 'package:flutter/material.dart';
import 'package:meals2/data/dummy_data.dart';
import 'package:meals2/screens/quiz.dart';

class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a quiz category')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Pick a category and test what you know about its meals.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          for (final category in availableCategories)
            Builder(builder: (context) {
              final count = dummyMeals
                  .where((m) => m.categories.contains(category.id))
                  .length;
              return Card(
                child: ListTile(
                  enabled: count > 0,
                  leading: CircleAvatar(backgroundColor: category.color),
                  title: Text(category.title),
                  subtitle: Text('$count meals'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => QuizScreen(category: category),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}