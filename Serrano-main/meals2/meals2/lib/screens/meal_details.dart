import 'package:flutter/material.dart';
import 'package:meals2/models/meal.dart';
import 'package:meals2/providers/favorites_store.dart';

/// Opens the details screen for [meal].
void openMealDetails(BuildContext context, Meal meal) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (ctx) => MealDetailsScreen(meal: meal)),
  );
}

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Text(
            text,
            style: theme.textTheme.titleLarge!.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          ListenableBuilder(
            listenable: favoritesStore,
            builder: (context, _) {
              final isFav = favoritesStore.isFavorite(meal);
              return IconButton(
                tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: Tween<double>(begin: 0.8, end: 1).animate(animation),
                    child: child,
                  ),
                  child: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    key: ValueKey(isFav),
                  ),
                ),
                onPressed: () {
                  final added = favoritesStore.toggle(meal);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(added
                          ? 'Added to favorites.'
                          : 'Removed from favorites.'),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.schedule, size: 18),
                        label: Text('${meal.duration} min'),
                      ),
                      Chip(
                        avatar: const Icon(Icons.work, size: 18),
                        label: Text(meal.complexityText),
                      ),
                      Chip(
                        avatar: const Icon(Icons.attach_money, size: 18),
                        label: Text(meal.affordabilityText),
                      ),
                      if (meal.isGlutenFree) const Chip(label: Text('Gluten-free')),
                      if (meal.isLactoseFree) const Chip(label: Text('Lactose-free')),
                      if (meal.isVegetarian) const Chip(label: Text('Vegetarian')),
                      if (meal.isVegan) const Chip(label: Text('Vegan')),
                    ],
                  ),
                  heading('Ingredients'),
                  for (final ingredient in meal.ingredients)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '• $ingredient',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  heading('Steps'),
                  for (var i = 0; i < meal.steps.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            child: Text('${i + 1}',
                                style: const TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              meal.steps[i],
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
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