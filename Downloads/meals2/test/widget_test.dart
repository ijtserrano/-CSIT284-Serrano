import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meals2/data/dummy_data.dart';
import 'package:meals2/providers/favorites_store.dart';
import 'package:meals2/screens/filters.dart';
import 'package:meals2/screens/meal_details.dart';

void main() {
  test('FavoritesStore toggles a meal on and off', () {
    final store = FavoritesStore();
    final meal = dummyMeals.first;

    expect(store.toggle(meal), isTrue);
    expect(store.isFavorite(meal), isTrue);
    expect(store.toggle(meal), isFalse);
    expect(store.meals, isEmpty);
  });

  testWidgets('MealDetailsScreen shows ingredients and steps', (tester) async {
    final meal = dummyMeals.first;
    await tester.pumpWidget(MaterialApp(home: MealDetailsScreen(meal: meal)));

    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Steps'), findsOneWidget);
  });

  testWidgets('FiltersScreen shows all four switches', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: FiltersScreen(currentFilters: kInitialFilters)),
    );

    expect(find.byType(SwitchListTile), findsNWidgets(4));
  });
}