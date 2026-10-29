import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:meals2/models/meal.dart';

class FavoriteMealsNotifier extends Notifier<List<Meal>> {
  @override
  List<Meal> build() => [];

  /// Returns true if the meal was added, false if it was removed.
  bool toggleMealFavoriteStatus(Meal meal) {
    final isFavorite = state.any((m) => m.id == meal.id);

    if (isFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoriteMealsProvider =
    NotifierProvider<FavoriteMealsNotifier, List<Meal>>(
  FavoriteMealsNotifier.new,
);