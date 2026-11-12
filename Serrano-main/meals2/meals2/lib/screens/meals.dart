import 'package:flutter/material.dart';
import 'package:meals2/models/meal.dart';
import 'package:meals2/screens/meal_details.dart';
import 'package:meals2/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    this.emptyHint = 'Try selecting a different category.',
  });

  /// When null, no AppBar is shown (used inside the tab layout).
  final String? title;
  final List<Meal> meals;
  final String emptyHint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) => MealItem(
        meal: meals[index],
        onSelectMeal: (meal) => openMealDetails(context, meal),
      ),
    );

    if (meals.isEmpty) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Uh oh ... nothing here!',
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                emptyHint,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (title == null) return content;

    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: content,
    );
  }
}